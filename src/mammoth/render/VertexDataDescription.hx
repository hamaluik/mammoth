package mammoth.render;

import kha.graphics4.VertexStructure;
import kha.graphics4.VertexData;

class VertexDataDescription {
	public var name:String;
	public var data:Array<Float>;
	public var structure:VertexStructure;
	public var usage:kha.graphics4.Usage;

	public function new(name:String, data:Array<Float>) {
		this.name = name;
		this.data = data;
		this.structure = new VertexStructure();
		this.usage = kha.graphics4.Usage.StaticUsage;
	}

	public function addStructure(name:String, type:VertexData):VertexDataDescription {
		structure.add(name, type);
		return this;
	}

	public function setUsage(usage:kha.graphics4.Usage):VertexDataDescription {
		this.usage = usage;
		return this;
	}
}