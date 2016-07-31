package mammoth.components;

import edge.IComponent;
import kha.Color;

class SpotLight implements IComponent {
	public var colour:Color = Color.White;
	public var distance:Float = 25.0;
	public var cutOff:Float = 25 * Math.PI / 180;
	public var outerCutOff:Float = 35 * Math.PI / 180;

	public function new() {}

	public function setColour(colour:Color):SpotLight {
		this.colour = colour;
		return this;
	}

	public function setDistance(distance:Float):SpotLight {
		this.distance = distance;
		return this;
	}

	public function setCutOffs(innerDeg:Float, outerDeg:Float):SpotLight {
		this.cutOff = innerDeg * Math.PI / 180;
		this.outerCutOff = outerDeg * Math.PI / 180;
		return this;
	}
}