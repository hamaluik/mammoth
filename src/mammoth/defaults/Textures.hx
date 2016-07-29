package mammoth.defaults;

import haxe.io.Bytes;
import haxe.Resource;
import kha.Image;

class Textures {
	#if js
	public static function FromBytes(data:Bytes, extension:String):js.html.ImageElement {
		var b64:String = haxe.crypto.Base64.encode(data);
		var src:String = 'data:image/${extension};base64,${b64}';
		var img:js.html.ImageElement = cast js.Browser.document.createElement("img");
		img.src = src;
		return img;
	}
	#end

	public static function UVGrid():Image {
		var data:Bytes = Resource.getBytes("image/uvgrid.png");
		#if js
		return Image.fromImage(FromBytes(data, "png"), true);
		#else
		return Image.fromBytes(data, 1024, 1024);
		#end
	}
}