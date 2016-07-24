package mammoth.ecs.c;

import kha.Color;
import mammoth.ecs.Component;

enum ProjectionMode {
	Orthographic(size:Float);
	Perspective(fieldOfView:Float);
}

class Camera extends Component {
	private var _pDirty:Bool = true;
	private var _vDirty:Bool = true;
	private var _vpDirty:Bool = true;

	public var near(default, set):Float = 0.1;
	public function set_near(n:Float):Float {
		_pDirty = true;
		return near = n;
	}
	public var far(default, set):Float = 100;
	public function set_far(f:Float):Float {
		_pDirty = true;
		return far = f;
	}

	public var aspect(default, set):Float = 4/3;
	public function set_aspect(a:Float):Float {
		_pDirty = true;
		return aspect = a;
	}

	public var projection(default, set):ProjectionMode = ProjectionMode.Perspective(60);
	public function set_projection(p:ProjectionMode):ProjectionMode {
		_pDirty = true;
		return projection = p;
	}

	public var clearColour:Color = Color.Black;

	public function new() super();
}