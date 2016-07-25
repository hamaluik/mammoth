package mammoth.lib;

import edge.ISystem;
import kha.math.FastMatrix4;
import mammoth.lib.Transform;

class ModelMatrixSystem implements ISystem {
	public function update(t:Transform) {
		t.modelWasUpdated = false;
		if(!t.mDirty) return;

		var translation:FastMatrix4 = FastMatrix4.translation(t.localPosition.x, t.localPosition.y, t.localPosition.z);
		var scale:FastMatrix4 = FastMatrix4.scale(t.localScale.x, t.localScale.y, t.localScale.z);
		var m:FastMatrix4 = translation.multmat(t.localRotation).multmat(scale);
		if(t.parent != null) {
			m = FastMatrix4.identity().multmat(t.parent.model).multmat(m);
		}

		t.model = m;
		t.mDirty = false;
		t.modelWasUpdated = true;
	}
}