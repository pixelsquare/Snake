package snake.screens;

import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.display.Texture;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.System;
import flambe.Disposer;
import snake.utils.AssetName;

import snake.screens.SceneManager;
import snake.screens.IScreen;
import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class ChooseYourLevelScreen extends Component implements IScreen
{
	public var screenName(default, null): String = "Choose your level Screen";
	public var screenScene(default, null): Entity;
	public var screenDisposer(default, null): Disposer;
	
	public function new () { }
	
	public function Initialize(manager: SceneManager): Entity {
		screenScene = new Entity();
		screenScene.add(this);
		
		var background: FillSprite = new FillSprite(0x202020, System.stage.width, System.stage.height);
		screenScene.addChild(new Entity().add(background));
		
		var chooseYourLevelFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var chooseYourLevelText: TextSprite = new TextSprite(chooseYourLevelFont, "Choose your level");
		chooseYourLevelText.centerAnchor();
		chooseYourLevelText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.3
		);
		screenScene.addChild(new Entity().add(chooseYourLevelText));
		
		for (ii in 0...3) {
			var levelEntity: Entity = new Entity();
			var levelBG: ImageSprite = new ImageSprite(manager.buttonDefaultTexture);
			levelBG.centerAnchor();
			
			screenDisposer.add(levelBG.pointerIn.connect(function(event: PointerEvent) {
				levelBG.texture = manager.buttonHoverTexture;
			}));
			
			screenDisposer.add(levelBG.pointerOut.connect(function(event: PointerEvent) {
				levelBG.texture = manager.buttonDefaultTexture;
			}));
			
			screenDisposer.add(levelBG.pointerDown.connect(function(event: PointerEvent) {
				levelBG.texture = manager.buttonActiveTexture;
			}));
			
			screenDisposer.add(levelBG.pointerUp.connect(function(event: PointerEvent) {
				levelBG.texture = manager.buttonDefaultTexture;
				manager.ShowGameScreen(false);
				manager.ShowGameDelayScreen(false);
				manager.gameGameScreen.InitializeSnake(ii);			
			}));
			
			levelEntity.add(levelBG);
			
			var levelFont: Font = new Font(manager.gameAssets, AssetName.FONT_APPLE_GARAMOND_32);
			var levelText: TextSprite = new TextSprite(levelFont, "Level " + (ii + 1));
			levelText.centerAnchor();
			
			// Set buttons on position
			levelBG.setXY(
				System.stage.width / 2,
				System.stage.height * 0.3 + ((ii + 1) * 60)
			);
			
			// Set text position relative to its BG
			levelText.setXY(
				levelText.x._ + (levelBG.getNaturalWidth() / 2),
				levelText.y._ + (levelBG.getNaturalHeight() / 2)
			);
			
			levelEntity.addChild(new Entity().add(levelText));
			
			screenScene.addChild(levelEntity);
		}
		
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