package mammoth.components;

import edge.IComponent;
import kha.Color;

class PointLight implements IComponent {
	public var colour:Color = Color.White;
	public var distance:Float = 25.0;

	public function new() {}

	public function setColour(colour:Color):PointLight {
		this.colour = colour;
		return this;
	}

	public function setDistance(distance:Float):PointLight {
		this.distance = distance;
		return this;
	}
}