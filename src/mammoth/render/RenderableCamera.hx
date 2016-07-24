package mammoth.render;

import kha.Color;
import kha.math.FastMatrix4;

class RenderableCamera {
	public var view:FastMatrix4;
	public var projection:FastMatrix4;
	public var viewProjection:FastMatrix4;
	public var clearColour:Color;
}