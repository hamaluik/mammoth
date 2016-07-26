package mammoth.components;

import edge.IComponent;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.math.FastVector4;
import kha.math.Quaternion;

class Transform implements IComponent {
	public var parent:Transform = null;
	public var localPosition(default, set):FastVector3 = new FastVector3(0, 0, 0);
	inline function set_localPosition(v:FastVector3):FastVector3 {
		mDirty = true;
		return localPosition = v;
	}
	public var localRotation(default, set):Quaternion = new Quaternion(0, 0, 0, 1);
	inline function set_localRotation(q:Quaternion):Quaternion {
		mDirty = true;
		return localRotation = q;
	}
	public var localScale(default, set):FastVector3 = new FastVector3(1, 1, 1);
	inline function set_localScale(v:FastVector3):FastVector3 {
		mDirty = true;
		return localScale = v;
	}

	public var mDirty:Bool = true;
	public var mWasDirty:Bool = false;
	public var m:FastMatrix4 = FastMatrix4.identity();

	public function new(?pos:FastVector3, ?rot:Quaternion, ?scale:FastVector3, ?parent:Transform) {
		if(pos != null) localPosition = pos;
		if(rot != null) localRotation = rot;
		if(scale != null) localScale = scale;
		this.parent = parent;
		mDirty = true;
	}

	public function setLocalPosition(x:Float, y:Float, z:Float):Transform {
		localPosition.x = x;
		localPosition.y = y;
		localPosition.z = z;
		mDirty = true;
		return this;
	}

	public function setLocalRotation(rot:Quaternion):Transform {
		localRotation = rot;
		mDirty = true;
		return this;
	}

	public function setLocalScale(sx:Float, sy:Float, sz:Float):Transform {
		localScale.x = sx;
		localScale.y = sy;
		localScale.z = sz;
		mDirty = true;
		return this;
	}
}