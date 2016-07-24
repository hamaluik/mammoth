package mammoth.render;

import haxe.ds.Vector;
import kha.FastFloat;
import kha.math.FastMatrix4;
import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.math.FastVector4;
import kha.Color;

enum TUniform {
	Bool(x:Bool);
	Int(x:Int);
	Float(x:FastFloat);
	Float2(x:FastFloat, y:FastFloat);
	Float3(x:FastFloat, y:FastFloat, z:FastFloat);
	Float4(x:FastFloat, y:FastFloat, z:FastFloat, w:FastFloat);
	Floats(x:Vector<FastFloat>);
	Vector2(x:FastVector2);
	Vector3(x:FastVector3);
	Vector4(x:FastVector4);
	Matrix4(v:FastMatrix4);
	RGB(c:Color);
	RGBA(c:Color);
}