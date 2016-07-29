package;

import kha.Color;
import kha.math.FastVector2;
import kha.math.Quaternion;
import kha.math.Vector3;
import mammoth.components.Camera;
import mammoth.components.Light;
import mammoth.components.MeshRenderer;
import mammoth.components.Transform;
import mammoth.defaults.Materials;
import mammoth.defaults.Textures;
import mammoth.Mammoth;
import mammoth.defaults.Primitives;
import mammoth.render.TUniform;

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

		// create a cube
		Mammoth.engine.create([
			new Transform()
				.setLocalPosition(0, 0, 0.7306668)
				.setLocalRotation(new Quaternion(0, 0, 0.383734, 0.9234437))
				.setLocalScale(1, 1, 1),
			new MeshRenderer()
				.setMesh(Primitives.cube(true, true, true))
				.setMaterial(Materials.diffuse()
					.setUniform("text", TUniform.Texture2D(Textures.UVGrid())))
		]);

		// and a light!
		Mammoth.engine.create([
			new Transform()
				.setLocalPosition(0, 0, 3.5)
				.setLocalRotation(new Quaternion(0.2128308, 0.4044054, 0.0346047, 0.888798))
				.setLocalScale(1, 1, 1),
			new Light()
				.setTemperature(5500)
				.setType(LightType.Directional)
		]);

		Mammoth.start();
	}
}