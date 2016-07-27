package mammoth.systems;

import edge.ISystem;
import edge.View;
import kha.math.FastMatrix4;
import kha.math.FastVector4;
import mammoth.components.Camera;
import mammoth.components.Light;
import mammoth.components.MeshRenderer;
import mammoth.components.Transform;
import mammoth.Mammoth;
import mammoth.render.Material;

class RenderSystem implements ISystem {
	var transforms:View<{ transform:Transform }>;
	var lights:View<{ transform:Transform, light:Light }>;
	var objects:View<{ transform:Transform, renderer:MeshRenderer }>;

	public function before() {
		// calculate the model matrices for all tranforms
		for(t in transforms) {
			calculateModelMatrix(t.data.transform);
		}

		Mammoth.graphics.begin();
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
		Mammoth.graphics.viewport(vpX, vpY, vpW, vpH);
		Mammoth.graphics.scissor(vpX, vpY, vpW, vpH);
		Mammoth.graphics.clear(camera.clearColour);

		for(o in objects) {
			var object = o.data;
			var material:Material = object.renderer.material;
			// set the MVP
			if(camera.vDirty || camera.pDirty || object.transform.mWasDirty) {
				material.setUniform("MVP", Matrix4(FastMatrix4.identity()
					.multmat(camera.vp)
					.multmat(object.transform.m)));
			}

			// set the VP (for shading)
			if(camera.vDirty || camera.pDirty) material.setUniform("VP", Matrix4(camera.vp));
			if(object.transform.mWasDirty) material.setUniform("M", Matrix4(object.transform.m));
			if(camera.vDirty) material.setUniform("V", Matrix4(camera.v));
			if(camera.pDirty) material.setUniform("P", Matrix4(camera.p));

			// set light data
			var lightIndex:Int = 0;
			for(l in lights) {
				var light:Light = l.data.light;

				// set the uniforms
				switch(light.type) {
					case LightType.Directional: {
						// calculate the light direction
						var lightDir:FastVector4 = l.data.transform.m.multvec(new FastVector4(0, 0, 1, 0));
						
						material.setUniform('DirLights[${lightIndex}].dir', Float3(lightDir.x, lightDir.y, lightDir.z));
						material.setUniform('DirLights[${lightIndex}].col', RGB(light.colour));
					}
				}

				// move on
				lightIndex++;
			}

			// now render!
			material.apply(Mammoth.graphics);
			object.renderer.mesh.bindBuffers(Mammoth.graphics);
			Mammoth.graphics.drawIndexedVertices();
		}

		camera.vDirty = false;
		camera.pDirty = false;
	}

	public function after() {
		Mammoth.graphics.end();
	}
}