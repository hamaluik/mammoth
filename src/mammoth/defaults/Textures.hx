package mammoth.defaults;

import haxe.Resource;
import kha.Image;

class Textures {
	public static function UVGrid():Image {
		return Image.fromBytes(Resource.getBytes("image/uvgrid.png"), 1024, 1024);
	}
}