package;

import flixel.addons.async.FlxAsyncLoop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.resolution.RatioResolutionPolicy;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColorUtil;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;


/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	private var _grpProgress:FlxGroup;
	private var _grpFinished:FlxGroup;
	private var _loopOne:FlxAsyncLoop;
	private var _maxItems:Int = 5000;
	private var _bar:FlxBar;
	private var _barText:FlxText;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.resolutionPolicy = new RatioResolutionPolicy();

		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		_grpProgress = new FlxGroup();
		_grpFinished = new FlxGroup(_maxItems);
		
		_loopOne = new FlxAsyncLoop(_maxItems, addItem, _grpFinished, 100);
		
		
		add(_grpProgress);
		add(_grpFinished);
		
		_bar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, FlxG.width - 50, 50, null, "", 0, 100, true);
		
		_bar.currentValue = 0;
		FlxSpriteUtil.screenCenter(_bar);
		_grpProgress.add(_bar);
		
		
		_barText = new FlxText(0, 0, FlxG.width, "Loading... 0 / " + _maxItems);
		_barText.setFormat(null, 32, 0xffffff, "center", FlxText.BORDER_OUTLINE, 0x000000);
		FlxSpriteUtil.screenCenter(_barText);
		_grpProgress.add(_barText);
		
		_grpProgress.visible = true;
		_grpFinished.visible = false;
		
		super.create();
	}
	
	public function addItem():Void
	{	
		_grpFinished.add(new FlxSprite(FlxRandom.intRanged(0, FlxG.width), FlxRandom.intRanged(0, FlxG.height)).makeGraphic(10, 10, FlxColorUtil.getRandomColor(0, 255, 255)));
		_bar.currentValue = (_grpFinished.members.length / _maxItems) * 100;
		_barText.text = "Loading... " + _grpFinished.members.length + " / " + _maxItems;
		FlxSpriteUtil.screenCenter(_barText);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (!_loopOne.started)
		{
			_loopOne.start();
		}
		else
		{
			if (!_loopOne.finished)
			{
				_loopOne.update();
				_grpProgress.update();
			}
			else
			{
				_grpFinished.visible = true;
				_grpProgress.visible = false;
				_grpProgress.update();
			}
		}
		
		//super.update();
	}
	
	override public function draw():Void 
	{
		if (!_loopOne.finished)
			_grpProgress.draw();
		else
			_grpFinished.draw();
		//super.draw();
		
	}
}