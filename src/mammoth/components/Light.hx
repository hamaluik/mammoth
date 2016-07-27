package mammoth.components;

import edge.IComponent;
import kha.Color;

enum LightType {
	Directional;
}

class Light implements IComponent {
	public var colour:Color = Color.White;
	public var type:LightType = LightType.Directional;

	public function new() {}

	public function setColour(colour:Color):Light {
		this.colour = colour;
		return this;
	}

	// from http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
	public function setTemperature(temperature:Float):Light {
		function clamp(x:Float, min:Float, max:Float):Float {
			if(x < min) return min;
			if(x > max) return max;
			return x;
		}

		temperature = clamp(temperature, 1000, 40000);
		temperature /= 100;

		var red:Float = 255;
		if(temperature > 66) {
			red = temperature - 60;
			red = 329.698727446 * Math.pow(red, -0.1332047592);
		}
		var r:Float = clamp(red, 0, 255) / 255;

		var green:Float;
		if(temperature <= 66) {
			green = temperature;
	        green = 99.4708025861 * Math.log(green) - 161.1195681661;
	    }
	    else {
	        green = temperature - 60;
	        green = 288.1221695283 * Math.pow(green, -0.0755148492);
		}
		var g:Float = clamp(green, 0, 255) / 255;

		var blue:Float = 255;
		if(temperature <= 19) blue = 0;
		else if(temperature < 66) {
            blue = temperature - 10;
            blue = 138.5177312231 * Math.log(blue) - 305.0447927307;
		}
		var b:Float = clamp(blue, 0, 255) / 255;

		this.colour = Color.fromFloats(r, g, b, 1);
		return this;
	}

	public function setType(type:LightType):Light {
		this.type = type;
		return this;
	}
}