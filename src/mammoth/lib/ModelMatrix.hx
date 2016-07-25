package mammoth.lib;

import edge.IComponent;
import kha.math.FastMatrix4;

class ModelMatrix implements IComponent {
	public var m:FastMatrix4 = FastMatrix4.identity();

	public function new(){}
}