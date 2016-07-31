package mammoth.render;

import haxe.ds.StringMap;
import kha.graphics4.CompareMode;
import kha.graphics4.ConstantLocation;
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

	public function new(name:String, inputLayout:Array<VertexStructure>, vertexShader:VertexShader, fragmentShader:FragmentShader) {
		this.name = name;

		pipeline = new PipelineState();
		pipeline.inputLayout = inputLayout;
		pipeline.vertexShader = vertexShader;
		pipeline.fragmentShader = fragmentShader;
		pipeline.depthWrite = true;
		pipeline.depthMode = CompareMode.Less;
		pipeline.cullMode = CullMode.Clockwise;
		pipeline.compile();

		uniforms = new StringMap<Uniform>();
	}

	public function setUniform(name:String, value:TUniform):Material {
		if(uniforms.exists(name)) {
			uniforms.get(name).value = value;
		}
		else {
			var uniform:Uniform = new Uniform();
			uniform.value = value;
			uniforms.set(name, uniform);
		}
		return this;
	}

	public function bindUniforms() {
		for(name in uniforms.keys()) {
			var uniform:Uniform = uniforms.get(name);
			if(uniform.bound) continue;

			uniform.location = switch(uniform.value) {
				case Texture2D(_): TLocation.Texture(pipeline.getConstantLocation(name), pipeline.getTextureUnit(name));
				case _: TLocation.Uniform(pipeline.getConstantLocation(name));
			}
			uniform.bound = true;
		}
	}

	public function apply(g:Graphics) {
		g.setPipeline(pipeline);
		bindUniforms();

		for(uniform in uniforms) {
			switch(uniform.location) {
				case Uniform(location): {
					switch(uniform.value) {
						case Bool(b): g.setBool(location, b);
						case Int(i): g.setInt(location, i);
						case Float(x): g.setFloat(location, x);
						case Float2(x, y): g.setFloat2(location, x, y);
						case Float3(x, y, z): g.setFloat3(location, x, y, z);
						case Float4(x, y, z, w): g.setFloat4(location, x, y, z, w);
						case Floats(x): g.setFloats(location, x);
						case Vector2(v): g.setVector2(location, v);
						case Vector3(v): g.setVector3(location, v);
						case Vector4(v): g.setVector4(location, v);
						case Matrix4(m): g.setMatrix(location, m);
						case RGB(c): g.setFloat3(location, c.R, c.G, c.B);
						case RGBA(c): g.setFloat4(location, c.R, c.G, c.B, c.A);
						case _: throw 'Unhandled uniform type ${uniform.value}!';
					}
				}
				case Texture(location, unit): {
					switch(uniform.value) {
						case Texture2D(t, slot): {
							g.setInt(location, slot);
							g.setTexture(unit, t);
						}
						case _: throw 'Unhandled texture type ${uniform.value}!';
					}
				}
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