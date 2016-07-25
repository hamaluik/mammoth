package mammoth.components;

import edge.IComponent;
import kha.Color;
import kha.math.FastVector2;
import kha.math.FastMatrix4;

enum ProjectionMode {
	Orthographic(size:Float);
	Perspective(fieldOfView:Float);
}

class Camera implements IComponent {
	public var near(default, set):Float = 0.1;
	function set_near(n:Float):Float {
		pDirty = true;
		return near = n;
	}
	public var far(default, set):Float = 100;
	function set_far(f:Float):Float {
		pDirty = true;
		return far = f;
	}

	public var projection(default, set):ProjectionMode = ProjectionMode.Perspective(60);
	function set_projection(p:ProjectionMode):ProjectionMode {
		pDirty = true;
		return projection = p;
	}

	public var viewportMin:FastVector2 = new FastVector2(0, 0);
	public var viewportMax:FastVector2 = new FastVector2(1, 1);

	public var clearColour:Color = Color.Black;

	public var vDirty:Bool = true;
	public var pDirty:Bool = true;
	public var v:FastMatrix4 = FastMatrix4.identity();
	public var p:FastMatrix4 = FastMatrix4.identity();
	public var vp:FastMatrix4 = FastMatrix4.identity();

	public function new() {}

	public function setNearFar(near:Float, far:Float):Camera {
		this.near = near;
		this.far = far;
		return this;
	}

	public function setProjection(projection:ProjectionMode):Camera {
		this.projection = projection;
		return this;
	}

	public function setViewport(min:FastVector2, max:FastVector2):Camera {
		this.viewportMin = min;
		this.viewportMax = max;
		return this;
	}

	public function setClearColour(colour:Color):Camera {
		this.clearColour = colour;
		return this;
	}
}