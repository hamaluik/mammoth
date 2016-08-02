package mammoth.systems;

import edge.ISystem;
import edge.View;
import kha.graphics4.DepthStencilFormat;
import kha.graphics4.Graphics;
import kha.graphics4.TextureFormat;
import kha.Image;
import kha.math.FastMatrix4;
import kha.math.FastVector4;
import mammoth.components.Camera;
import mammoth.components.DirectionLight;
import mammoth.components.PointLight;
import mammoth.components.MeshRenderer;
import mammoth.components.SpotLight;
import mammoth.components.Transform;
import mammoth.defaults.Materials;
import mammoth.defaults.Primitives;
import mammoth.Mammoth;
import mammoth.render.Material;
import mammoth.render.Mesh;
import mammoth.render.TUniform;

class RenderSystem implements ISystem {
	var transforms:View<{ transform:Transform }>;
	var dirLights:View<{ transform:Transform, light:DirectionLight }>;
	var pointLights:View<{ transform:Transform, light:PointLight }>;
	var spotLights:View<{ transform:Transform, light:SpotLight }>;
	var objects:View<{ transform:Transform, renderer:MeshRenderer }>;

	var graphics:Graphics;
	var renderImage:Image;
	var screenMesh:Mesh;
	var gammaCorrection:Material;

	public function new() {
		renderImage = Image.createRenderTarget(
			Mammoth.width, Mammoth.height,
			TextureFormat.RGBA32, DepthStencilFormat.Depth24Stencil8,
			1);
		screenMesh = Primitives.screen();
		gammaCorrection = Materials.gammaCorrection();
	}

	public function before() {
		// calculate the model matrices for all tranforms
		for(t in transforms) {
			calculateModelMatrix(t.data.transform);
		}

		//graphics = Mammoth.frameBuffer.g4;
		graphics = renderImage.g4;
		graphics.begin();
	}

	private function calculateModelMatrix(t:Transform) {
		// early exit
		t.mWasDirty = false;
		if(!t.mDirty) return;

		// calculate the affine transformation matrix
		var translation:FastMatrix4 = FastMatrix4.translation(t.localPosition.x, t.localPosition.y, t.localPosition.z);
		var rotation:FastMatrix4 = FastMatrix4.fromMatrix4(t.localRotation.matrix());
		var scale:FastMatrix4 = FastMatrix4.scale(t.localScale.x, t.localScale.y, t.localScale.z);
		var m:FastMatrix4 = translation.multmat(rotation).multmat(scale);

		// apply its parent transform
		if(t.parent != null) {
			m = FastMatrix4.identity().multmat(t.parent.m).multmat(m);
		}

		t.m = m;
		t.mDirty = false;
		t.mWasDirty = true;
	}

	public function update(transform:Transform, camera:Camera) {
		// calculate the camera's matrices
		if(camera.vDirty || transform.mWasDirty) {
			camera.v = transform.m.inverse();
			camera.vDirty = true;
		}
		if(camera.pDirty) {
			var aspect:Float = Mammoth.width / Mammoth.height;
			camera.p = switch(camera.projection) {
				case ProjectionMode.Perspective(fov): FastMatrix4.perspectiveProjection(fov * Math.PI / 180, aspect, camera.near, camera.far);
				case ProjectionMode.Orthographic(halfY): {
					var halfX:Float = aspect * halfY;
					FastMatrix4.orthogonalProjection(-halfX, halfX, -halfY, halfY, camera.near, camera.far);
				}
			}
			camera.vp = FastMatrix4.identity().multmat(camera.p).multmat(camera.v);
		}

		// setup the viewport
		var vpX:Int = Std.int(camera.viewportMin.x * Mammoth.width);
		var vpY:Int = Std.int(camera.viewportMin.y * Mammoth.height);
		var vpW:Int = Std.int((camera.viewportMax.x - camera.viewportMin.x) * Mammoth.width);
		var vpH:Int = Std.int((camera.viewportMax.y - camera.viewportMin.y) * Mammoth.height);
		graphics.viewport(vpX, vpY, vpW, vpH);
		graphics.scissor(vpX, vpY, vpW, vpH);
		graphics.clear();
		// for some reason, clearing with a colour does weird things!
		//graphics.clear(camera.clearColour); // TODO: component-defined clearing

		Mammoth.stats.drawCalls = 0;
		for(o in objects) {
			var object = o.data;
			var material:Material = object.renderer.material;
			// set the MVP
			material.setUniform("MVP", TUniform.Matrix4(FastMatrix4.identity()
				.multmat(camera.vp)
				.multmat(object.transform.m)));

			// set the VP (for shading)
			material.setUniform("VP", TUniform.Matrix4(camera.vp));
			material.setUniform("M", TUniform.Matrix4(object.transform.m));
			material.setUniform("V", TUniform.Matrix4(camera.v));
			material.setUniform("P", TUniform.Matrix4(camera.p));

			// set the view position for shading
			material.setUniform("viewPos", TUniform.Float3(transform.m._30, transform.m._31, transform.m._32));

			// set light data
			var dirLightIndex:Int = 0;
			for(l in dirLights) {
				var lightDir:FastVector4 = l.data.transform.m.multvec(new FastVector4(0, 0, 1, 0));
				material.setUniform('dirLights[' + dirLightIndex + '].direction', TUniform.Float3(lightDir.x, lightDir.y, lightDir.z));
				material.setUniform('dirLights[' + dirLightIndex + '].colour', TUniform.RGB(l.data.light.colour));
				dirLightIndex++;
			}
			var pointLightIndex:Int = 0;
			for(l in pointLights) {
				var lt:Transform = l.data.transform;
				var light:PointLight = l.data.light;
				material.setUniform('pointLights[' + pointLightIndex + '].position', TUniform.Float3(lt.m._30, lt.m._31, lt.m._32));
				material.setUniform('pointLights[' + pointLightIndex + '].dist', TUniform.Float(light.distance));
				material.setUniform('pointLights[' + pointLightIndex + '].colour', TUniform.RGB(light.colour));
				pointLightIndex++;
			}
			var spotLightIndex:Int = 0;
			for(l in spotLights) {
				var lt:Transform = l.data.transform;
				var light:SpotLight = l.data.light;
				var lightDir:FastVector4 = lt.m.multvec(new FastVector4(0, 0, 1, 0));
				material.setUniform('spotLights[' + spotLightIndex + '].position', TUniform.Float3(lt.m._30, lt.m._31, lt.m._32));
				material.setUniform('spotLights[' + spotLightIndex + '].direction', TUniform.Float3(lightDir.x, lightDir.y, lightDir.z));
				material.setUniform('spotLights[' + spotLightIndex + '].dist', TUniform.Float(light.distance));
				material.setUniform('spotLights[' + spotLightIndex + '].colour', TUniform.RGB(light.colour));
				material.setUniform('spotLights[' + spotLightIndex + '].cutOff', TUniform.Float(light.cutOff));
				material.setUniform('spotLights[' + spotLightIndex + '].outerCutOff', TUniform.Float(light.outerCutOff));
				spotLightIndex++;
			}

			// now render!
			material.apply(graphics);
			object.renderer.mesh.bindBuffers(graphics);
			graphics.drawIndexedVertices();
			Mammoth.stats.drawCalls++;
		}

		camera.vDirty = false;
		camera.pDirty = false;
	}

	public function after() {
		graphics.end();

		// start applying post-effects
		Mammoth.frameBuffer.g4.begin();

		// gamma correction
		gammaCorrection.setUniform("screenSize", TUniform.Float2(Mammoth.width, Mammoth.height));
		gammaCorrection.setUniform("scene", TUniform.Texture2D(renderImage, 0));
		gammaCorrection.apply(Mammoth.frameBuffer.g4);
		screenMesh.bindBuffers(Mammoth.frameBuffer.g4);
		Mammoth.frameBuffer.g4.drawIndexedVertices();

		// stop applying post-effects
		Mammoth.frameBuffer.g4.end();
	}
}