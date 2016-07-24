package mammoth;

import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import mammoth.render.Renderer;

class Mammoth {
	public static var time(get, never):Float;
	static inline function get_time():Float return Scheduler.time();
	public static var dt(default, null):Float;
	public static var fps(default, null):Int;
	private static var _lastTime:Float;

	public static var onRenderStart(default, null):Array<Framebuffer->Void> = new Array<Framebuffer->Void>();
	public static var onRenderEnd(default, null):Array<Framebuffer->Void> = new Array<Framebuffer->Void>();
	public static var onUpdateStart(default, null):Array<Float->Void> = new Array<Float->Void>();
	public static var onUpdateEnd(default, null):Array<Float->Void> = new Array<Float->Void>();

	private static var _uuid:Int = 1;

	private static var renderer:Renderer;

	public static function init(
		title:String,
		width:UInt, height:UInt,
		updateRate:Float=60, loadAllAssets:Bool=true):Void {
		System.init({
			title: title,
			width: width,
			height: height
		},
		function() {
			if(loadAllAssets) {
				Assets.loadEverything(function() {
					start(updateRate);
				});
			}
			else {
				start(updateRate);
			}
		});
	}

	private static function start(updateRate:Float):Void {
		// todo: initialize input

		// initialize our renderer
		renderer = new Renderer();

		// start our loops!
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / updateRate);
		_lastTime = time;
	}

	private static function render(fb:Framebuffer):Void {
		for(cb in onRenderStart) cb(fb);
		renderer.render(fb.g4);
		for(cb in onRenderEnd) cb(fb);
	}

	private static function update():Void {
		dt = time - _lastTime;
		fps = Math.floor(1 / dt);

		for(cb in onUpdateStart) cb(dt);

		// todo: update

		for(cb in onUpdateEnd) cb(dt);
	}

	public static function UUID():Int {
		return _uuid++;
	}
}