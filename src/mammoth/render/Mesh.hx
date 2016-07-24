package mammoth.render;

import haxe.ds.StringMap;
import kha.arrays.Float32Array;
import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;

using Lambda;

class Mesh {
	private var _vertexBuffers:Array<VertexBuffer>;
	private var _indexBuffer:IndexBuffer;

	private var _built:Bool = false;

	public function new() {}

	public var vertexData:Array<VertexDataDescription> = new Array<VertexDataDescription>();
	public var indexData:Array<Int> = new Array<Int>();

	public var structures(get, never):Array<VertexStructure>;
	function get_structures():Array<VertexStructure> {
		return vertexData.map(function(d:VertexDataDescription):VertexStructure {
			return d.structure;
		});
	}

	public function buildBuffers() {
		// build our array of vertex buffers
		_vertexBuffers = new Array<VertexBuffer>();
		for(data in vertexData) {
			// instantiate the buffer
			var buffer:VertexBuffer = new VertexBuffer(
				data.data.length,
				data.structure,
				data.usage);

			// copy the data
			var vbData:Float32Array = buffer.lock();
			for(i in 0...vbData.length) {
				vbData.set(i, data.data[i]);
			}
			buffer.unlock();

			// store it for later
			_vertexBuffers.push(buffer);
		}

		// build the triangle index buffer
		_indexBuffer = new IndexBuffer(
			indexData.length,
			kha.graphics4.Usage.StaticUsage); // TODO: make changeable
		var iData:Array<Int> = _indexBuffer.lock();
		for(i in 0...iData.length) {
			iData[i] = indexData[i];
		}
		_indexBuffer.unlock();

		_built = true;
	}

	public function bindBuffers(g:Graphics) {
		if(!_built) buildBuffers();

		g.setVertexBuffers(_vertexBuffers);
		g.setIndexBuffer(_indexBuffer);
	}
}