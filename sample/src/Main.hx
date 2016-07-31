package;

import kha.Assets;
import kha.Color;
import kha.math.FastVector2;
import kha.math.Quaternion;
import kha.math.Vector3;
import mammoth.components.Camera;
import mammoth.components.DirectionLight;
import mammoth.components.MeshRenderer;
import mammoth.components.PointLight;
import mammoth.components.SpotLight;
import mammoth.components.Transform;
import mammoth.defaults.Materials;
import mammoth.defaults.Textures;
import mammoth.Mammoth;
import mammoth.defaults.Primitives;
import mammoth.render.Material;
import mammoth.render.TUniform;

using mammoth.util.Colour;

class Main {
	public static function main() {
		Mammoth.init('sample', 960, 540, onReady);
	}

	public static function onReady():Void {
		// create a camera
		Mammoth.engine.create([
			new Transform()
				.setLocalPosition(2.1810226, -4.74123, 2.361527)
				.setLocalRotation(new Quaternion(0.5776544, 0.1232913, 0.1594744, 0.7910011)),
			new Camera()
				.setNearFar(0.1, 100)
				.setProjection(ProjectionMode.Perspective(49.1343421))
				.setViewport(new FastVector2(0, 0), new FastVector2(1, 1))
				.setClearColour(Color.fromFloats(0.25, 0.25, 0.25))
		]);

		var mat:Material = Materials.blinnPhong()
			// TODO: clean up this texture business
			.setUniform("materialShininess", TUniform.Float(32))
			.setUniform("materialDiffuse", TUniform.Int(0))
			.setUniform("materialSpecular", TUniform.Int(1))
			.setUniform("materialDiffuse", TUniform.Texture2D(Assets.images.container_d))
			.setUniform("materialSpecular", TUniform.Texture2D(Assets.images.container_s));

		// create a cube
		Mammoth.engine.create([
			new Transform()
				.setLocalPosition(0, 0, 1.1864519)
				.setLocalRotation(new Quaternion(0, 0, 0.383734, 0.9234437))
				.setLocalScale(1, 1, 1),
			new MeshRenderer()
				.setMesh(Primitives.cube(true, true, true))
				.setMaterial(mat)
		]);

		// create a plane
		Mammoth.engine.create([
			new Transform()
				.setLocalPosition(0, 0, 0)
				.setLocalScale(5, 5, 5),
			new MeshRenderer()
				.setMesh(Primitives.plane(true, true, true))
				.setMaterial(mat)
		]);

		// a sun
		/*Mammoth.engine.create([
			new Transform()
				.setLocalPosition(0, 0, 3.5)
				.setLocalRotation(new Quaternion(0.2128308, 0.4044054, 0.0346047, 0.888798))
				.setLocalScale(1, 1, 1),
			new DirectionLight()
				.setColour(Color.White)
		]);

		// and a point light
		Mammoth.engine.create([
			new Transform()
				.setLocalPosition(-0.9209661, -0.9100119, 1.174525),
			new PointLight()
				.setColour(Color.fromFloats(0.25, 0.25, 0.25))
				.setDistance(25)
		]);*/

		// and a spotlight
		Mammoth.engine.create([
			new Transform()
				.setLocalPosition(1.5845933, 0.2877208, 1.1395212)
				.setLocalRotation(new Quaternion(0.0, 0.3367168, 0.0, 0.941606)),
			new SpotLight()
				.setColour(Color.White)
				.setDistance(2)
				.setCutOffs(40, 50)
		]);

		Mammoth.start();
	}
}