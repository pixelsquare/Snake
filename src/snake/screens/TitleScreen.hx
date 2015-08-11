package snake.screens;

import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.input.PointerEvent;
import flambe.scene.Scene;
import flambe.System;

import snake.core.GameManager;
import snake.core.SceneManager;
import snake.pxlSq.Utils;
import snake.screens.IScreen;
import snake.utils.AssetName;
import snake.utils.ScreenName;

import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class TitleScreen extends Component implements IScreen
{	
	public var screenBackground	(default, null): FillSprite;
	public var screenScene		(default, null): Scene;
	public var screenEntity		(default, null): Entity;
	public var screenDisposer	(default, null): Disposer;
	
	private var highScoreText: 	TextSprite;
	private var scoreText: 		TextSprite;
	private var canStart:		Bool;
	
	public function new () { }
	
	public function ScreenEntity(): Entity {	
		screenScene = new Scene();
		screenEntity = new Entity();
		
		screenEntity.add(this);
		screenEntity.add(screenScene);
		
		var gameAssets: AssetPack = GameManager.current.gameAssets;
		
		screenBackground = new FillSprite(SceneManager.SCENE_DEFAULT_BG, System.stage.width, System.stage.height);	
		screenEntity.addChild(new Entity().add(screenBackground));
		
		// Title text
		var titleFont: Font = new Font(gameAssets, AssetName.FONT_VANADINE_100);
		var titleText: TextSprite = new TextSprite(titleFont, "SNaKE");
		titleText.centerAnchor();
		titleText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.35
		);
		screenEntity.addChild(new Entity().add(titleText));
		
		// Click anywhere to start text
		var clickToStartFont: Font = new Font(gameAssets, AssetName.FONT_UNCERTAIN_SANS_32);
		var clickToStartText: TextSprite = new TextSprite(clickToStartFont, "Click anywhere to Start!");
		clickToStartText.centerAnchor();
		clickToStartText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.55
		);
		screenEntity.addChild(new Entity().add(clickToStartText));
		
		// Highscore text
		var highScoreFont: Font = new Font(gameAssets, AssetName.FONT_UNCERTAIN_SANS_40);
		highScoreText = new TextSprite(highScoreFont, "High Score");
		highScoreText.centerAnchor();
		highScoreText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.8
		);
		screenEntity.addChild(new Entity().add(highScoreText));
		
		// Score Text
		var scoreFont: Font = new Font(gameAssets, AssetName.FONT_UNCERTAIN_SANS_40);
		scoreText = new TextSprite(scoreFont, "00000");
		scoreText.setXY(
			highScoreText.x._ - (scoreText.getNaturalWidth() / 2),
			highScoreText.y._ + (scoreText.getNaturalHeight() / 2)
		);
		screenEntity.addChild(new Entity().add(scoreText));
		
		// Manually dispose pointer event
		screenDisposer.add(System.pointer.up.connect(function(event: PointerEvent) {
			if (!canStart)
				return;
			
			SceneManager.current.ShowChooseYourLevelScreen(true);
		}));
		
		screenDisposer.add(System.keyboard.down.connect(function(event: KeyboardEvent) {
			if (event.key == Key.R) {
				GameManager.current.ResetHighestScore();
				SetHighScoreDirty();
			}
		}));
		
		SetHighScoreDirty();
		
		screenDisposer.add(screenEntity);
		screenDisposer.add(screenScene);
		
		return screenEntity;
	}
	
	public function SetHighScoreDirty(): Void {
		scoreText.text = GameManager.current.gameHighScore + "";
		scoreText.setXY(
			highScoreText.x._ - (scoreText.getNaturalWidth() / 2),
			highScoreText.y._ + (scoreText.getNaturalHeight() / 2)
		);
	}
	
	public function SetBackgroundColor(color: Int): Void {
		screenBackground.color = color;
	}
	
	public function GetScreenName(): String {
		return ScreenName.SCREEN_TITLE;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		//Utils.ConsoleLog(GetScreenName() + " ADDED!");
		screenDisposer = owner.get(Disposer);
		if (screenDisposer == null) {
			owner.add(screenDisposer = new Disposer());
		}
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		canStart = System.pointer.isDown();
	}
	
	override public function onRemoved() 
	{
		super.onRemoved();
		//Utils.ConsoleLog(GetScreenName() + " REMOVED!");
	}
	
	override public function dispose() 
	{
		super.dispose();
		//Utils.ConsoleLog(GetScreenName() + " DISPOSED!");
		screenDisposer.dispose();
	}
}