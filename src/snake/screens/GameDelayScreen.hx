package snake.screens;

import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.scene.Scene;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.System;
import flambe.Disposer;
import haxe.Timer;

import snake.utils.AssetName;
import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameDelayScreen extends Component implements IScreen
{
	public var screenName(default, null): String = "Game Delay Screen";
	public var screenScene(default, null): Entity;
	public var screenDisposer(default, null): Disposer;
	
	private var time: Float;
	
	private static inline var COUNTDOWN_BLOAT_SIZE = 3;
	
	public function new () { }
	
	public function Initialize(manager: SceneManager): Entity {
		screenScene = new Entity();
		screenScene.add(new Scene(false));
		
		var background: FillSprite = new FillSprite(0x000000, System.stage.width, System.stage.height);
		background.alpha.animate(0, 0.5, 0.5);
		screenScene.addChild(new Entity().add(background));
		
		var gameStartingInFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var gameStartingInText: TextSprite = new TextSprite(gameStartingInFont, "Game starting in ...");
		gameStartingInText.centerAnchor();
		gameStartingInText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.4
		);
		screenScene.addChild(new Entity().add(gameStartingInText));
		
		var countdownFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var countdownText: TextSprite = new TextSprite(countdownFont, "3");
		countdownText.centerAnchor();
		countdownText.setScale(COUNTDOWN_BLOAT_SIZE);
		countdownText.setXY(
			gameStartingInText.x._ - (countdownText.getNaturalWidth() / 2),
			gameStartingInText.y._ + (gameStartingInText.getNaturalHeight() / 2) + (countdownText.getNaturalHeight() / 2)
		);
		screenScene.addChild(new Entity().add(countdownText));
		
		var time = SceneManager.GAME_DELAY;
		var script: Script = new Script();
		script.run(new Repeat(new Sequence([
			new CallFunction(function() { 
				countdownText.scaleX.animateTo(1, 1);
				countdownText.scaleY.animateTo(1, 1);
			}),
			new Delay(1),
			new CallFunction(function() {
				time--;
				if (time < 0) {
					time = 0;
					script.dispose();
					manager.gameDirector.unwindToScene(manager.gameGameScreen.screenScene);
				}
				else {
					countdownText.text = time + "";
					countdownText.setScale(COUNTDOWN_BLOAT_SIZE);	
				}
			})
		])));
		
		screenScene.add(script);
		
		return screenScene;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		Utils.ConsoleLog(screenName + " ADDED!");
		screenDisposer = owner.get(Disposer);
		if (screenDisposer == null) {
			owner.add(screenDisposer = new Disposer());
		}
	}
	
	override public function onRemoved() 
	{
		super.onRemoved();
		Utils.ConsoleLog(screenName + " REMOVED!");
	}
	
	override public function dispose() 
	{
		super.dispose();
		Utils.ConsoleLog(screenName + " DISPOSED!");
		screenDisposer.dispose();
	}
}