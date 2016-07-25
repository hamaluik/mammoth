package mammoth.systems;

import edge.ISystem;
import kha.math.FastMatrix4;
import mammoth.components.Transform;

/**
 *  should this be done as a getter instead so that parent transforms are calculated correctly?
 */
class TransformSystem implements ISystem {
	public function update(t:Transform) {
		// early exit
		t.mWasDirty = false;
		if(!t.mDirty) return;

		// calculate the affine transformation matrix
		var translation:FastMatrix4 = FastMatrix4.translation(t.localPosition.x, t.localPosition.y, t.localPosition.z);
		var rotation:FastMatrix4 = FastMatrix4.fromMatrix4(t.localRotation.matrix());
		var scale:FastMatrix4 = FastMatrix4.scale(t.localScale.x, t.localScale.y, t.localScale.z);
		var m:FastMatrix4 = translation.multmat(rotation).multmat(scale);

		// apply its parent transform
		if(t.parent != null) {
			m = FastMatrix4.identity().multmat(t.parent.m).multmat(m);
		}

		t.m = m;
		t.mDirty = false;
		t.mWasDirty = true;
	}
}