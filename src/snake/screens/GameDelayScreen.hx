package snake.screens;

import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.scene.Director;
import flambe.scene.Scene;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.System;
import flambe.animation.Ease;

import snake.core.GameManager;
import snake.core.SceneManager;
import snake.pxlSq.Utils;
import snake.utils.AssetName;
import snake.utils.ScreenName;

import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameDelayScreen extends Component implements IScreen
{
	public var screenBackground		(default, null): FillSprite;
	public var screenScene			(default, null): Scene;
	public var screenEntity			(default, null): Entity;
	public var screenDisposer		(default, null): Disposer;
	
	private var gameStartingInText: 	TextSprite;
	private var countdownText:	 		TextSprite;
	
	public function new () { }
	
	public function ScreenEntity(): Entity {
		screenScene = new Scene(false);
		screenEntity = new Entity();
		
		screenEntity.add(this);
		screenEntity.add(screenScene);
		
		var gameAssets: AssetPack = GameManager.current.gameAssets;
		var gameDirector: Director = GameManager.current.gameDirector;
		
		// Create Background
		screenBackground = new FillSprite(SceneManager.SCENE_DEFAULT_BG, System.stage.width, System.stage.height);
		screenBackground.alpha.animate(0, 0.8, 0.5);
		screenEntity.addChild(new Entity().add(screenBackground));
		
		var gameStartingInFont: Font = new Font(gameAssets, AssetName.FONT_UNCERTAIN_SANS_50);
		gameStartingInText = new TextSprite(gameStartingInFont, "Game starting in ...");
		gameStartingInText.centerAnchor();
		gameStartingInText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.4
		);
		gameStartingInText.alpha.animate(0, 1, 0.5);
		screenEntity.addChild(new Entity().add(gameStartingInText));
		
		var countdownFont: Font = new Font(gameAssets, AssetName.FONT_UNCERTAIN_SANS_50);
		countdownText = new TextSprite(countdownFont, "3");
		countdownText.centerAnchor();
		countdownText.setXY(
			gameStartingInText.x._ - (countdownText.getNaturalWidth() / 2),
			gameStartingInText.y._ + (gameStartingInText.getNaturalHeight() / 2) + (countdownText.getNaturalHeight() / 2)
		);
		screenEntity.addChild(new Entity().add(countdownText));
		
		var time = SceneManager.GAME_WAITING_TIME;
		var script: Script = new Script();
		script.run(new Repeat(
			new Sequence([
				new CallFunction(function() {
					countdownText.text = (time == 0) ? "GO!" : time + "";
					SetScoreTextDirty();
					countdownText.alpha.animate(-0.8, 1, 1);
					countdownText.y.animate(
						System.stage.height * 0.3, 
						gameStartingInText.y._ + (gameStartingInText.getNaturalHeight() / 2) + (countdownText.getNaturalHeight() / 2), 
						1,
						Ease.elasticInOut
					);
				}),
				new Delay(1),
				new CallFunction(function() {
					time--;
					if (time < 0) {
						time = 0;
						countdownText.alpha.animate(1, 0, 1);
						gameDirector.unwindToScene(SceneManager.current.gameGameScreen.screenEntity);
						script.dispose();
					}
					else {
						if (time == 0) {
							gameStartingInText.alpha.animate(1, 0, 1);
						}						
					}
				})
			])
		));
		screenEntity.add(script);
		
		//var time = SceneManager.GAME_WAITING_TIME;
		//var script: Script = new Script();
		//script.run(new Repeat(new Sequence([
			//new CallFunction(function() { 
				//countdownText.scaleX.animateTo(1, 1);
				//countdownText.scaleY.animateTo(1, 1);
			//}),
			//new Delay(1),
			//new CallFunction(function() {
				//time--;
				//if (time < 0) {
					//time = 0;
					//script.dispose();
					//gameDirector.unwindToScene(SceneManager.current.gameGameScreen.screenEntity);
				//}
				//else {
					//if (time == 0) {
						//gameStartingInText.alpha.animateTo(0, 1);
					//}
					//countdownText.text = (time == 0) ? "GO!" : time + "";
					//countdownText.setScale(COUNTDOWN_BLOAT_SIZE);	
					//SetScoreTextDirty();
				//}
			//})
		//])));
		//
		//screenEntity.add(script);
		
		screenDisposer.add(screenEntity);
		screenDisposer.add(screenScene);
		
		return screenEntity;
	}
	
	public function SetScoreTextDirty(): Void {
		countdownText.setXY(
			gameStartingInText.x._ - (countdownText.getNaturalWidth() / 2),
			gameStartingInText.y._ + (gameStartingInText.getNaturalHeight() / 2) + (countdownText.getNaturalHeight() / 2)
		);
	}
	
	public function SetBackgroundColor(color: Int): Void {
		screenBackground.color = color;
	}
	
	public function GetScreenName(): String {
		return ScreenName.SCREEN_GAME_DELAY;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		Utils.ConsoleLog(GetScreenName() + " ADDED!");
		screenDisposer = owner.get(Disposer);
		if (screenDisposer == null) {
			owner.add(screenDisposer = new Disposer());
		}
	}
	
	override public function onRemoved() 
	{
		super.onRemoved();
		Utils.ConsoleLog(GetScreenName() + " REMOVED!");
	}
	
	override public function dispose() 
	{
		super.dispose();
		Utils.ConsoleLog(GetScreenName() + " DISPOSED!");
		screenDisposer.dispose();
	}
}