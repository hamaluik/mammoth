package mammoth.render;

import haxe.ds.StringMap;
import kha.graphics4.CompareMode;
import kha.graphics4.CullMode;
import kha.graphics4.FragmentShader;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import mammoth.render.TUniform;

class Material {
	public var name(default, null):String;
	public var pipeline(default, null):PipelineState;
	public var uniforms:StringMap<Uniform>;

	private var _bound:Bool = false;

	public function new(name:String, inputLayout:Array<VertexStructure>, vertexShader:VertexShader, fragmentShader:FragmentShader) {
		this.name = name;

		pipeline = new PipelineState();
		pipeline.inputLayout = inputLayout;
		pipeline.vertexShader = vertexShader;
		pipeline.fragmentShader = fragmentShader;
		pipeline.depthWrite = true;
		pipeline.depthMode = CompareMode.Less;
		pipeline.cullMode = CullMode.CounterClockwise;
		pipeline.compile();

		uniforms = new StringMap<Uniform>();
	}

	public function setUniform(name:String, value:TUniform) {
		if(uniforms.exists(name)) {
			uniforms.get(name).value = value;
		}
		else {
			var uniform:Uniform = new Uniform();
			uniform.value = value;
			uniforms.set(name, uniform);
			_bound = false;
		}
		if(!uniforms.get(name).bound) uniforms.get(name).location = pipeline.getConstantLocation(name);
	}

	public function bindUniforms() {
		for(name in uniforms.keys()) {
			uniforms.get(name).location = pipeline.getConstantLocation(name);
		}
		_bound = true;
	}

	public function apply(g:Graphics) {
		if(!_bound) bindUniforms();
		g.setPipeline(pipeline);

		for(uniform in uniforms) {
			switch(uniform.value) {
				case Bool(b): g.setBool(uniform.location, b);
				case Int(i): g.setInt(uniform.location, i);
				case Float(x): g.setFloat(uniform.location, x);
				case Float2(x, y): g.setFloat2(uniform.location, x, y);
				case Float3(x, y, z): g.setFloat3(uniform.location, x, y, z);
				case Float4(x, y, z, w): g.setFloat4(uniform.location, x, y, z, w);
				case Floats(x): g.setFloats(uniform.location, x);
				case Vector2(v): g.setVector2(uniform.location, v);
				case Vector3(v): g.setVector3(uniform.location, v);
				case Vector4(v): g.setVector4(uniform.location, v);
				case Matrix4(m): g.setMatrix(uniform.location, m);
				case RGB(c): g.setFloat3(uniform.location, c.R, c.G, c.B);
				case RGBA(c): g.setFloat4(uniform.location, c.R, c.G, c.B, c.A);
				case _: throw 'Unhandled uniform type ${uniform.value}!';
			}
		}
	}

	public function toString() {
		return haxe.Json.stringify({
			name: name,
			uniforms: uniforms
		});
	}
}