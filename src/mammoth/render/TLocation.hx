package mammoth.render;

import kha.graphics4.ConstantLocation;
import kha.graphics4.TextureUnit;

enum TLocation {
	Uniform(location:ConstantLocation);
	Texture(location:ConstantLocation, unit:TextureUnit);
}