package mammoth.ecs;

/**
 * Base class for all components.
 */
@:autoBuild(mammoth.macros.ComponentIndexer.index())
class Component {
	/**
	 * The ID type of the component class
	 */
	public static var tid(default, null):Int = -1;

	/**
	 * The ID type of the component's class
	 */
	public var _tid(get, null):Int;
	public function get__tid():Int { return Component.tid; };

	/**
	 * A unique ID for this component
	 */
	public var id(get, null):Int;

	/**
	 * Empty constructor
	 */
	public function new() {
		id = mammoth.Mammoth.UUID();
	}
}