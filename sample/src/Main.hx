package;

import kha.Color;
import kha.math.FastVector2;
import kha.math.Quaternion;
import kha.math.Vector3;
import mammoth.components.Camera;
import mammoth.components.MeshRenderer;
import mammoth.components.Transform;
import mammoth.defaults.Materials;
import mammoth.Mammoth;
import mammoth.defaults.Primitives;

class Main {
	public static function main() {
		Mammoth.init('sample', 960, 540, onReady);
	}

	public static function onReady():Void {
		// create a camera
		Mammoth.engine.create([
			new Transform()
				.setLocalPosition(0, -5, 0)
				.setLocalRotation(Quaternion.fromAxisAngle(new Vector3(1, 0, 0), 90 * Math.PI / 180)),
			new Camera()
				.setNearFar(0.1, 100)
				.setProjection(ProjectionMode.Perspective(60))
				.setViewport(new FastVector2(0, 0), new FastVector2(1, 1))
				.setClearColour(Color.fromFloats(0.25, 0.25, 0.25))
		]);

		// create a cube
		Mammoth.engine.create([
			new Transform()
				.setLocalPosition(0, 0, 0)
				.setLocalRotation(new Quaternion(0, 0, 0, 1))
				.setLocalScale(1, 1, 1),
			new MeshRenderer()
				.setMesh(Primitives.cube())
				.setMaterial(Materials.unlitColour())
		]);

		Mammoth.start();
	}
}