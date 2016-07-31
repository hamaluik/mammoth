package mammoth.defaults;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.Resource;
import kha.graphics4.TextureFormat;
import kha.graphics4.Usage;
import kha.Image;

class Textures {
	#if js
	private static function webIMG(data:Bytes, ext:String):js.html.ImageElement {
		var b64:String = haxe.crypto.Base64.encode(data);
		var src:String = 'data:image/${ext};base64,${b64}';
		var img:js.html.ImageElement = cast js.Browser.document.createElement("img");
		img.src = src;
		return img;
	}
	#end

	public static function UVGrid():Image {
		var data:Bytes = Resource.getBytes("image/uvgrid.png");
		#if js
		return Image.fromImage(webIMG(data, "png"), true);
		#else
		return Image.fromBytes(data, 1024, 1024);
		#end
	}

	public static function Black():Image {
		var data:Bytes = Resource.getBytes("image/black.png");
		#if js
		return Image.fromImage(webIMG(data, "png"), true);
		#else
		return Image.fromBytes(data, 1, 1);
		#end
	}

	public static function White():Image {
		var data:Bytes = Resource.getBytes("image/white.png");
		#if js
		return Image.fromImage(webIMG(data, "png"), true);
		#else
		return Image.fromBytes(data, 1, 1);
		#end
	}

	public static function SpecRing():Image {
		var data:Bytes = Resource.getBytes("image/specring.png");
		#if js
		return Image.fromImage(webIMG(data, "png"), true);
		#else
		return Image.fromBytes(data, 256, 256);
		#end
	}
}