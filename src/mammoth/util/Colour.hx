package mammoth.util;

import kha.Color;

class Colour {
	public static function tempToColour(temperature:Float):Color {
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

		return Color.fromFloats(r, g, b, 1);
	}
}