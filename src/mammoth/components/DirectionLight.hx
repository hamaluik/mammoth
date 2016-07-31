package mammoth.components;

import edge.IComponent;
import kha.Color;

class DirectionLight implements IComponent {
	public var colour:Color = Color.White;

	public function new() {}

	public function setColour(colour:Color):DirectionLight {
		this.colour = colour;
		return this;
	}
}