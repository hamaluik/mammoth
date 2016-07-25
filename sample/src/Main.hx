package;

import kha.Color;
import kha.math.FastVector2;
import mammoth.lib.Camera;
import mammoth.lib.Transform;
import mammoth.Mammoth;

class Main {
	public static function main() {
		Mammoth.init('sample', 960, 540, onReady);
	}

	public static function onReady():Void {
		// create a camera
		Mammoth.engine.create([
			new Transform(),
			new Camera()
				.setNearFar(0.1, 100)
				.setProjection(ProjectionMode.Perspective(60))
				.setViewport(new FastVector2(0, 0), new FastVector2(0.5, 1))
				.setClearColour(Color.Yellow)
		]);

		Mammoth.start();
	}
}