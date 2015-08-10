package snake.pxlSq;

import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.display.Texture;
import flambe.Entity;
import flambe.scene.Scene;
import flambe.System;
import flambe.input.PointerEvent;
import flambe.Disposer;
import snake.screens.SceneManager;
import snake.utils.AssetName;

import snake.screens.IScreen;
/**
 * ...
 * @author Anthony Ganzon
 */
class GameOverScreen extends Component implements IScreen
{
	public var screenName(default, null): String = "Game Over Screen";
	public var screenScene(default, null): Entity;
	public var screenDisposer(default, null): Disposer;
	
	public function new() { }
	
	public function Initialize(manager: SceneManager): Entity {
		screenScene = new Entity();
		screenScene.add(this);
		screenScene.add(new Scene(false));
		
		var background: FillSprite = new FillSprite(0x000000, System.stage.width, System.stage.height);
		background.alpha.animate(0, 0.85, 0.5);
		screenScene.addChild(new Entity().add(background));
		
		var gameOverFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var gameOverText: TextSprite = new TextSprite(gameOverFont, "Game Over");
		gameOverText.centerAnchor();
		gameOverText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.3
		);
		screenScene.addChild(new Entity().add(gameOverText));
		
		var yourScoreFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var yourScoreText: TextSprite = new TextSprite(yourScoreFont, "Your Score");
		yourScoreText.centerAnchor();
		yourScoreText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.45
		);
		screenScene.addChild(new Entity().add(yourScoreText));
		
		var scoreFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var scoreText: TextSprite = new TextSprite(scoreFont, "0000");
		scoreText.setXY(
			yourScoreText.x._ - (scoreText.getNaturalWidth() / 2),
			yourScoreText.y._ + (scoreText.getNaturalHeight() / 2)
		);
		screenScene.addChild(new Entity().add(scoreText));
		
		var goToMenuEntity: Entity = new Entity();
		var goToMenuBG: ImageSprite = new ImageSprite(manager.buttonDefaultTexture);
		goToMenuBG.centerAnchor();
		
		screenDisposer.add(goToMenuBG.pointerIn.connect(function(event: PointerEvent) {
			goToMenuBG.texture = manager.buttonHoverTexture;
		}));
		
		screenDisposer.add(goToMenuBG.pointerOut.connect(function(event: PointerEvent) {
			goToMenuBG.texture = manager.buttonDefaultTexture;
		}));
		
		screenDisposer.add(goToMenuBG.pointerDown.connect(function(event: PointerEvent) {
			goToMenuBG.texture = manager.buttonActiveTexture;
		}));
		
		screenDisposer.add(goToMenuBG.pointerUp.connect(function(event: PointerEvent) {
			goToMenuBG.texture = manager.buttonDefaultTexture;
			manager.ShowTitleScreen(true);
		}));
			
		goToMenuBG.setXY(
			System.stage.width / 2,
			System.stage.height * 0.7
		);
		goToMenuEntity.add(goToMenuBG);
		
		var goToMenuFont: Font = new Font(manager.gameAssets, AssetName.FONT_APPLE_GARAMOND_32);
		var goToMenuText: TextSprite = new TextSprite(goToMenuFont, "Go To Menu");
		goToMenuText.centerAnchor();
		goToMenuText.setXY(
			goToMenuText.x._ + (goToMenuBG.getNaturalWidth() / 2),
			goToMenuText.y._ + (goToMenuBG.getNaturalHeight() / 2)
		);
		goToMenuEntity.addChild(new Entity().add(goToMenuText));
		
		screenScene.addChild(goToMenuEntity);
		
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