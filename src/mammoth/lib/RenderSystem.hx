package mammoth.lib;

import edge.ISystem;
import edge.View;
import mammoth.lib.Camera;
import mammoth.lib.MeshRenderer;
import mammoth.lib.Transform;
import mammoth.lib.ViewProjectionMatrix;
import mammoth.Mammoth;

class RenderSystem implements ISystem {
	var objects:View<{ model:ModelMatrix, renderer:MeshRenderer }>;

	public function before() {
		Mammoth.graphics.begin();
	}

	public function update(viewProjection:ViewProjectionMatrix, cam:Camera) {
		// Mammoth.graphics.viewport(); // TODO
		Mammoth.graphics.clear(cam.clearColour);

		for(o in objects) {
			var object = o.data;
			// todo: calculate MVP
			// todo: apply uniforms to the material

			// now render!
			object.renderer.material.apply(Mammoth.graphics);
			object.renderer.mesh.bindBuffers(Mammoth.graphics);
			Mammoth.graphics.drawIndexedVertices();
		}
	}

	public function after() {
		Mammoth.graphics.end();
	}
}