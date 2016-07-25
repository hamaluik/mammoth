package mammoth.lib;

import edge.IComponent;
import kha.math.FastMatrix4;

class ViewProjectionMatrix implements IComponent {
	public var v:FastMatrix4 = FastMatrix4.identity();
	public var p:FastMatrix4 = FastMatrix4.identity();
	public var vp:FastMatrix4 = FastMatrix4.identity();

	public function new(){}
}