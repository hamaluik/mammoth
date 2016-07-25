package mammoth.render;

import kha.Color;
import kha.math.FastMatrix4;
import kha.math.FastVector2;

class RenderableCamera {
	public var view:FastMatrix4;
	public var projection:FastMatrix4;
	public var viewProjection:FastMatrix4;
	public var clearColour:Color;

	public var viewportMin:FastVector2;
	public var viewportSize:FastVector2;

	public var vDirty:Bool;
	public var pDirty:Bool;

	public function new() {
		view = FastMatrix4.identity();
		projection = FastMatrix4.identity();
		viewProjection = FastMatrix4.identity();
		clearColour = Color.Black;
		viewportMin = new FastVector2(0, 0);
		viewportSize = new FastVector2(0, 0);
		vDirty = true;
		pDirty = true;
	}
}