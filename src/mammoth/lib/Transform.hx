package mammoth.lib;

import edge.IComponent;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.math.FastVector4;
import kha.math.Quaternion;
import mammoth.lib.Transform;

class Transform implements IComponent {
	public var parent:Transform = null;
	public var localPosition:FastVector3 = new FastVector3(0, 0, 0);
	public var localRotation:FastMatrix4 = FastMatrix4.rotation(0, 0, 0);
	public var localScale:FastVector3 = new FastVector3(1, 1, 1);

	public var mDirty:Bool = true;

	public function new(?pos:FastVector3, ?rot:FastMatrix4, ?scale:FastVector3, ?parent:Transform) {
		if(pos != null) localPosition = pos;
		if(rot != null) localRotation = rot;
		if(scale != null) localScale = scale;
		this.parent = parent;
	}
}