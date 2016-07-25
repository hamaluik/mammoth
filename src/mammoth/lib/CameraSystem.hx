package mammoth.lib;

import edge.ISystem;
import kha.math.FastMatrix4;
import kha.System;
import mammoth.lib.Camera;
import mammoth.lib.Transform;
import mammoth.render.RenderableCamera;

class CameraSystem implements ISystem {
	public function update(t:Transform, c:Camera) {
		// if we're not dirty, peace out early
		if(!t.modelWasUpdated && !c.pDirty) return;

		// get the renderer's copy of the camera
		var cam:RenderableCamera = Mammoth.renderer.camera(c.cameraID);

		// update each of the matrices
		if(t.modelWasUpdated) {
			cam.view = t.model.inverse();
			cam.vDirty = true;
		}
		if(c.pDirty) {
			var aspect:Float = System.windowWidth() / System.windowHeight();
			cam.projection = switch(c.projection) {
				case ProjectionMode.Perspective(fov): FastMatrix4.perspectiveProjection(fov, aspect, c.near, c.far);
				case ProjectionMode.Orthographic(halfY): {
					var halfX:Float = aspect * halfY;
					FastMatrix4.orthogonalProjection(-halfX, halfX, -halfY, halfY, c.near, c.far);
				}
			}
			cam.pDirty = true;
		}
		if(t.modelWasUpdated || c.pDirty) {
			cam.viewProjection = FastMatrix4.identity().multmat(cam.projection);
			cam.viewProjection.multmat(cam.view);
			c.pDirty = false;
		}

		cam.clearColour = c.clearColour;
		cam.viewportMin.x = c.viewportMin.x * System.windowWidth();
		cam.viewportMin.y = c.viewportMin.y * System.windowHeight();
		cam.viewportSize.x = (c.viewportMax.x - c.viewportMin.x) * System.windowWidth();
		cam.viewportSize.y = (c.viewportMax.y - c.viewportMin.y) * System.windowHeight();
	}
}