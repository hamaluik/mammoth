package mammoth;

import edge.Engine;
import edge.Phase;
import kha.Assets;
import kha.Framebuffer;
import kha.graphics4.Graphics;
import kha.Scheduler;
import kha.System;
import mammoth.defaults.Fonts;
import mammoth.systems.RenderSystem;
import zui.Id;
import zui.Zui;
import mammoth.util.Stats;

class Mammoth {
	// time tools
	public static var time(get, never):Float;
	static inline function get_time():Float return Scheduler.time();
	public static var dt(default, null):Float;

	public static var width(get, never):Int;
	static inline function get_width():Int return System.windowWidth();
	public static var height(get, never):Int;
	static inline function get_height():Int return System.windowHeight();

	// additional events to listen to (outside of the ECS)
	public static var onRenderStart(default, null):Array<Framebuffer->Void> = new Array<Framebuffer->Void>();
	public static var onRenderEnd(default, null):Array<Framebuffer->Void> = new Array<Framebuffer->Void>();
	public static var onUpdateStart(default, null):Array<Float->Void> = new Array<Float->Void>();
	public static var onUpdateEnd(default, null):Array<Float->Void> = new Array<Float->Void>();

	// parts of our system
	public static var engine:Engine;
	public static var updatePhase:Phase;
	public static var renderPhase:Phase;

	// internal values
	private static var _updateRate:Float;
	private static var _lastTime:Float;
	private static var _uuid:Int = 1;

	// debug tools
	public static var stats:Stats = new Stats();
	private static var _ui:Zui;
	private static var _showDebug:Bool = false;

	public static var fullscreen(get, set):Bool;
	public static function get_fullscreen():Bool {
		return kha.SystemImpl.isFullscreen();
	}
	public static function set_fullscreen(v:Bool):Bool {
		if(v) kha.SystemImpl.requestFullscreen();
		else {
			kha.SystemImpl.exitFullscreen();
			if(mouseLocked)
				mouseLocked = false;
		}
		return fullscreen;
	}

	public static var mouseLocked(get, set):Bool;
	public static function get_mouseLocked():Bool
		return kha.SystemImpl.isMouseLocked();
	public static function set_mouseLocked(v:Bool):Bool {
		if(v) kha.SystemImpl.lockMouse();
		else kha.SystemImpl.unlockMouse();
		return mouseLocked;
	}

	@:allow(mammoth.systems.RenderSystem)
	private static var frameBuffer:Framebuffer;

	public static function init(
		title:String,
		width:UInt, height:UInt,
		?onReady:Void->Void,
		updateRate:Float=60, loadAllAssets:Bool=true):Void {
		_updateRate = updateRate;
		System.init({
			title: title,
			width: width,
			height: height
		},
		function() {
			if(loadAllAssets) {
				Assets.loadEverything(function() {
					prepare(onReady);
				});
			}
			else {
				prepare(onReady);
			}
		});
	}

	private static function prepare(onReady:Void->Void):Void {
		// initialize our ECS
		engine = new Engine();
		updatePhase = engine.createPhase();
		renderPhase = engine.createPhase();

		// set up our render system
		renderPhase.add(new RenderSystem());

		#if debug
		// initialize our debug UI
		_ui = new Zui(Fonts.DroidSans());

		// initialize our debug input
		kha.input.Keyboard.get().notify(function(k:kha.Key, c:String):Void {
			switch(k) {
				case kha.Key.CHAR: if(c == '`') _showDebug = !_showDebug;
				case _: {}
			}
		}, null);
		#end

		if(onReady != null) onReady();
	}

	public static function start():Void {
		_lastTime = time;
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / _updateRate);
	}

	private static function render(fb:Framebuffer):Void {
		var start:Float = System.time;
		for(cb in onRenderStart) cb(fb);

		frameBuffer = fb;
		renderPhase.update(0);

		for(cb in onRenderEnd) cb(fb);
		var end:Float = System.time;
		stats.renderTime = end - start;

		#if debug
		if(_showDebug) {
			_ui.begin(fb.g2);
			if(_ui.window(Id.window(), System.windowWidth() - 150, 0, 150, 200)) {
					_ui.row([0.5, 0.5]);
						_ui.text('FPS', Zui.ALIGN_LEFT);
						_ui.text('${stats.fps}', Zui.ALIGN_RIGHT);

					_ui.row([0.5, 0.5]);
						_ui.text('Update:', Zui.ALIGN_LEFT);
						_ui.text('${Math.fround(stats.updateTime*100000) / 100} ms', Zui.ALIGN_RIGHT);

					_ui.row([0.5, 0.5]);
						_ui.text('Render:', Zui.ALIGN_LEFT);
						_ui.text('${Math.fround(stats.renderTime*100000) / 100} ms', Zui.ALIGN_RIGHT);

					_ui.row([0.5, 0.5]);
						_ui.text('Draw calls:', Zui.ALIGN_LEFT);
						_ui.text('${stats.drawCalls}', Zui.ALIGN_RIGHT);
			}
			_ui.end();
		}
		#end
	}

	private static function update():Void {
		dt = time - _lastTime;
		_lastTime = time;
		stats.fps = Math.floor(1 / dt);

		var start:Float = System.time;
		for(cb in onUpdateStart) cb(dt);

		// run the update phase
		updatePhase.update(dt);

		// todo: fixed-timestep physics phase?

		for(cb in onUpdateEnd) cb(dt);
		var end:Float = System.time;
		stats.updateTime = end - start;
	}

	public static function UUID():Int {
		return _uuid++;
	}
}