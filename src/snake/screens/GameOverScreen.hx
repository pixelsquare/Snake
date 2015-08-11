package snake.screens;

import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.Disposer;
import flambe.Entity;
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
class GameOverScreen extends Component implements IScreen
{
	public var screenBackground		(default, null): FillSprite;
	public var screenScene			(default, null): Scene;
	public var screenEntity			(default, null): Entity;
	public var screenDisposer		(default, null): Disposer;
	
	private var yourScoreText: 	TextSprite;
	private var scoreText: 		TextSprite;
	
	public function new() { }
	
	public function ScreenEntity(): Entity {
		screenScene = new Scene(false);
		screenEntity = new Entity();
		
		screenEntity.add(this);
		screenEntity.add(screenScene);
		
		var gameAssets: AssetPack = GameManager.current.gameAssets;
		
		screenBackground = new FillSprite(SceneManager.SCENE_DEFAULT_BG, System.stage.width, System.stage.height);
		screenBackground.alpha.animate(0, 0.85, 0.5);
		screenEntity.addChild(new Entity().add(screenBackground));
		
		var gameOverFont: Font = new Font(gameAssets, AssetName.FONT_ARIAL_32);
		var gameOverText: TextSprite = new TextSprite(gameOverFont, "Game Over");
		gameOverText.centerAnchor();
		gameOverText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.3
		);
		screenEntity.addChild(new Entity().add(gameOverText));
		
		var yourScoreFont: Font = new Font(gameAssets, AssetName.FONT_ARIAL_32);
		yourScoreText = new TextSprite(yourScoreFont, "Your Score");
		yourScoreText.centerAnchor();
		yourScoreText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.45
		);
		screenEntity.addChild(new Entity().add(yourScoreText));
		
		var scoreFont: Font = new Font(gameAssets, AssetName.FONT_ARIAL_32);
		scoreText = new TextSprite(scoreFont, "0000");
		scoreText.setXY(
			yourScoreText.x._ - (scoreText.getNaturalWidth() / 2),
			yourScoreText.y._ + (scoreText.getNaturalHeight() / 2)
		);
		screenEntity.addChild(new Entity().add(scoreText));
		
		var goToMenuEntity: Entity = new Entity();
		screenDisposer.add(goToMenuEntity);
		
		var goToMenuBG: ImageSprite = new ImageSprite(GameManager.current.buttonDefaultTexture);
		goToMenuBG.centerAnchor();
		
		screenDisposer.add(goToMenuBG.pointerIn.connect(function(event: PointerEvent) {
			goToMenuBG.texture = GameManager.current.buttonHoverTexture;
		}));
		
		screenDisposer.add(goToMenuBG.pointerOut.connect(function(event: PointerEvent) {
			goToMenuBG.texture = GameManager.current.buttonDefaultTexture;
		}));
		
		screenDisposer.add(goToMenuBG.pointerDown.connect(function(event: PointerEvent) {
			goToMenuBG.texture = GameManager.current.buttonActiveTexture;
		}));
		
		screenDisposer.add(goToMenuBG.pointerUp.connect(function(event: PointerEvent) {
			goToMenuBG.texture = GameManager.current.buttonDefaultTexture;
			SceneManager.current.ShowTitleScreen(true);
		}));
			
		goToMenuBG.setXY(
			System.stage.width / 2,
			System.stage.height * 0.7
		);
		goToMenuEntity.add(goToMenuBG);
		
		var goToMenuFont: Font = new Font(gameAssets, AssetName.FONT_APPLE_GARAMOND_32);
		var goToMenuText: TextSprite = new TextSprite(goToMenuFont, "Go To Menu");
		goToMenuText.centerAnchor();
		goToMenuText.setXY(
			goToMenuText.x._ + (goToMenuBG.getNaturalWidth() / 2),
			goToMenuText.y._ + (goToMenuBG.getNaturalHeight() / 2)
		);
		goToMenuEntity.addChild(new Entity().add(goToMenuText));
		
		screenEntity.addChild(goToMenuEntity);
		
		SetScoreDirty();
	
		screenDisposer.add(screenEntity);
		screenDisposer.add(screenScene);
		
		return screenEntity;
	}
	
	public function SetScoreDirty(): Void {
		scoreText.text = GameManager.current.gameScore + "";
		scoreText.setXY(
			yourScoreText.x._ - (scoreText.getNaturalWidth() / 2),
			yourScoreText.y._ + (scoreText.getNaturalHeight() / 2)
		);
	}
	
	public function SetBackgroundColor(color: Int): Void {
		screenBackground.color = color;
	}
	
	public function GetScreenName(): String {
		return ScreenName.SCREEN_GAME_OVER;
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