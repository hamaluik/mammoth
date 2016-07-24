package mammoth.ecs.c;

import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.math.FastVector4;
import kha.math.Quaternion;
import mammoth.ecs.Component;

class Transform extends Component {
	public var Parent:Transform = null;
	public var LocalPosition:FastVector3 = new FastVector3(0, 0, 0);
	public var LocalRotation:FastMatrix4 = FastMatrix4.rotation(0, 0, 0);
	public var LocalScale:FastVector3 = new FastVector3(1, 1, 1);

	public function new() super();
}