package mammoth.render;

import kha.math.FastMatrix4;
import kha.graphics4.Graphics;
import mammoth.render.RenderableMesh;
import mammoth.render.RenderableCamera;

class Renderer {
	public var cameras:Array<RenderableCamera> = new Array<RenderableCamera>();
	public var renderables:Array<RenderableMesh> = new Array<RenderableMesh>();

	public static var drawCalls(default, null):Int = 0;

	public function new() {}

	private function preProcess() {
		// TODO: caching
		// set transformation uniforms
		for(camera in cameras) {
			for(renderable in renderables) {
				// calculate the MVP for this camera-object
				renderable.material.setUniform("MVP",
					Matrix4(
						FastMatrix4.identity()
						.multmat(camera.viewProjection)
						.multmat(renderable.model)));

				// set the render uniforms
				renderable.material.setUniform("VP", Matrix4(camera.viewProjection));
				renderable.material.setUniform("M", Matrix4(renderable.model));
				renderable.material.setUniform("V", Matrix4(camera.view));
				renderable.material.setUniform("P", Matrix4(camera.projection));
			}
		}
	}

	public function render(g:Graphics) {
		preProcess();
		drawCalls = 0;

		g.begin();
		for(camera in cameras) {
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