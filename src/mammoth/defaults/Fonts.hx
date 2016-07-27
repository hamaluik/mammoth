package mammoth.defaults;

import haxe.Resource;
import kha.Blob;
import kha.Font;
import kha.Kravur;

class Fonts {
	public static function DroidSans():Font {
		var fontFile:Blob = Blob.fromBytes(Resource.getBytes("font/DroidSans.ttf"));
		return new Kravur(fontFile);
	}
}