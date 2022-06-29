package android;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSave;
import flixel.math.FlxPoint;

import android.FlxVirtualPad;
import android.FlxHitbox;

class Config {
	var save:FlxSave;

	public function new() {
		save = new FlxSave();
		save.bind("saved-controls");
	}

	public function getcontrolmode():Int {
		if (save.data.buttonsmode != null) 
			return save.data.buttonsmode[0];
		return 0;
	}

	public function setcontrolmode(mode:Int = 0):Int {
		if (save.data.buttonsmode == null) save.data.buttonsmode = new Array();
		save.data.buttonsmode[0] = mode;
		save.flush();
		return save.data.buttonsmode[0];
	}

	public function savecustom(_pad:FlxVirtualPad) {
		if (save.data.buttons == null)
		{
			save.data.buttons = new Array();
			for (buttons in _pad){
				save.data.buttons.push(FlxPoint.get(buttons.x, buttons.y));
			}
		}else{
			var tempCount:Int = 0;
			for (buttons in _pad){
				save.data.buttons[tempCount] = FlxPoint.get(buttons.x, buttons.y);
				tempCount++;
			}
		}
		save.flush();
	}

	public function loadcustom(_pad:FlxVirtualPad):FlxVirtualPad {
		if (save.data.buttons == null) 
			return _pad;
		var tempCount:Int = 0;
		for(buttons in _pad){
			buttons.x = save.data.buttons[tempCount].x;
			buttons.y = save.data.buttons[tempCount].y;
			tempCount++;
		}	
		return _pad;
	}
}

class AndroidControls extends FlxSpriteGroup {
	public var mode:ControlsGroup = HITBOX;

	public var hbox:FlxHitbox;
	public var vpad:FlxVirtualPad;

	var config:Config;

	public function new() {
		super();

		config = new Config();

		mode = getModeFromNumber(config.getcontrolmode());

		switch (mode){
			case VIRTUALPAD_RIGHT:
				initControler(0);
			case VIRTUALPAD_LEFT:
				initControler(1);
			case VIRTUALPAD_CUSTOM:
				initControler(2);
			case HITBOX:
				initControler(4);
			case KEYBOARD:// nothing
				initControler(5);
		}
	}

	function initControler(vpadMode:Int) {
		switch (vpadMode){
			case 0:
				vpad = new FlxVirtualPad(RIGHT_FULL, A_D);	
				vpad = config.loadcustom(vpad);
				add(vpad);						
			case 1:
				vpad = new FlxVirtualPad(FULL, A_D);
				vpad = config.loadcustom(vpad);
				add(vpad);			
			case 2:
				vpad = new FlxVirtualPad(FULL, A_D);
				vpad = config.loadcustom(vpad);
				add(vpad);	
			case 3:
				hbox = new FlxHitbox();
				add(hbox);		
			  vpad = new FlxVirtualPad(NONE, A_D);
			  vpad = config.loadcustom(vpad);
				add(vpad);	
			case 4:
				//nothing
			default:
				//nothing
		}
	}

	public static function getModeFromNumber(modeNum:Int):ControlsGroup {
		return switch (modeNum){
			case 0: 
				VIRTUALPAD_RIGHT;
			case 1: 
				VIRTUALPAD_LEFT;
			case 2: 
				VIRTUALPAD_CUSTOM;
			case 3:	
				HITBOX;
			case 4: 
				KEYBOARD;
			default: 
				VIRTUALPAD_RIGHT;
		}
	}
}

enum ControlsGroup {
	VIRTUALPAD_RIGHT;
	VIRTUALPAD_LEFT;
	VIRTUALPAD_CUSTOM;
	HITBOX;
	KEYBOARD;
}
