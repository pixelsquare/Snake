package snake;

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

import snake.SceneManager;
import snake.IScreen;
import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class ChooseYourLevelScreen extends Component implements IScreen
{
	public var screenDisposer(default, null): Disposer;
	
	public function new () { }
	
	public function Initialize(manager: SceneManager): Entity {
		var scene: Entity = new Entity();
		scene.add(this);
		
		var background: FillSprite = new FillSprite(0x202020, System.stage.width, System.stage.height);
		scene.addChild(new Entity().add(background));
		
		var chooseYourLevelFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var chooseYourLevelText: TextSprite = new TextSprite(chooseYourLevelFont, "Choose your level");
		chooseYourLevelText.centerAnchor();
		chooseYourLevelText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.3
		);
		scene.addChild(new Entity().add(chooseYourLevelText));
		
		for (ii in 0...3) {
			var levelEntity: Entity = new Entity();
			var levelBG: ImageSprite = new ImageSprite(manager.buttonDefaultTexture);
			levelBG.centerAnchor();
			
			levelBG.pointerIn.connect(function(event: PointerEvent) {
				levelBG.texture = manager.buttonHoverTexture;
			});
			
			levelBG.pointerOut.connect(function(event: PointerEvent) {
				levelBG.texture = manager.buttonDefaultTexture;
			});
			
			levelBG.pointerDown.connect(function(event: PointerEvent) {
				levelBG.texture = manager.buttonActiveTexture;
			});
			
			levelBG.pointerUp.connect(function(event: PointerEvent) {
				levelBG.texture = manager.buttonDefaultTexture;
				manager.ShowGameScreen(false);
			});
			
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
			
			scene.addChild(levelEntity);
		}
		
		return scene;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		Utils.ConsoleLog("ADDED!");
	}
	
	override public function onRemoved() 
	{
		super.onRemoved();
		Utils.ConsoleLog("REMOVED!");
	}
	
	override public function dispose() 
	{
		super.dispose();
		Utils.ConsoleLog("DISPOSED!");
		screenDisposer.dispose();
	}
}