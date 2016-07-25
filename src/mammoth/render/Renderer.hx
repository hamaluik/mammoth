package mammoth.render;

import haxe.ds.IntMap;
import kha.math.FastMatrix4;
import kha.graphics4.Graphics;
import mammoth.render.RenderableMesh;
import mammoth.render.RenderableCamera;

class Renderer {
	public var drawCalls(default, null):Int = 0;
	public var culledObjects(default, null):Int = 0;

	var cameras:IntMap<RenderableCamera> = new IntMap<RenderableCamera>();
	var renderables:IntMap<RenderableMesh> = new IntMap<RenderableMesh>();

	public function new() {}

	public function camera(id:Int):RenderableCamera {
		if(!cameras.exists(id)) cameras.set(id, new RenderableCamera());
		return cameras.get(id);
	}

	public function removeCamera(id:Int) {
		cameras.remove(id);
	}

	private function preProcess() {
		// TODO: caching!
		// set transformation uniforms
		for(camera in cameras) {
			// set the transformations
			for(renderable in renderables) {
				// calculate the MVP for this camera-object
				renderable.material.setUniform("MVP",
					Matrix4(
						FastMatrix4.identity()
						.multmat(camera.viewProjection)
						.multmat(renderable.model)));

				// set the render uniforms
				if(camera.pDirty || camera.vDirty)
					renderable.material.setUniform("VP", Matrix4(camera.viewProjection));
				// todo: model dirty
				renderable.material.setUniform("M", Matrix4(renderable.model));
				if(camera.vDirty)
					renderable.material.setUniform("V", Matrix4(camera.view));
				if(camera.pDirty)
					renderable.material.setUniform("P", Matrix4(camera.projection));
			}

			camera.vDirty = false;
			camera.pDirty = false;
		}
	}

	public function render(g:Graphics) {
		preProcess();
		drawCalls = 0;

		g.begin();
		for(camera in cameras) {
			// set the viewport
			g.viewport(
				Std.int(camera.viewportMin.x), Std.int(camera.viewportMin.y),
				Std.int(camera.viewportSize.x), Std.int(camera.viewportSize.y));

			// clear it!
			g.clear(camera.clearColour);

			// render everything
			// todo: cull!
			for(renderable in renderables) {
				renderable.material.apply(g);
				renderable.mesh.bindBuffers(g); 
				g.drawIndexedVertices();
				drawCalls++;
			}
		}
		g.end();
	}
}