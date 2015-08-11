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
import flambe.animation.Ease;

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
class ChooseYourLevelScreen extends Component implements IScreen
{
	public var screenBackground		(default, null): FillSprite;
	public var screenScene			(default, null): Scene;
	public var screenEntity			(default, null): Entity;
	public var screenDisposer		(default, null): Disposer;
	
	public function new () { }
	
	public function ScreenEntity(): Entity {
		screenScene = new Scene();
		screenEntity = new Entity();
		
		screenEntity.add(this);
		screenEntity.add(screenScene);
		
		var gameAssets: AssetPack = GameManager.current.gameAssets;
		
		screenBackground = new FillSprite(SceneManager.SCENE_DEFAULT_BG, System.stage.width, System.stage.height);
		screenEntity.addChild(new Entity().add(screenBackground));
		
		var chooseYourLevelFont: Font = new Font(gameAssets, AssetName.FONT_VANADINE_60);
		var chooseYourLevelText: TextSprite = new TextSprite(chooseYourLevelFont, "Choose your level");
		chooseYourLevelText.centerAnchor();
		chooseYourLevelText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.3
		);
		chooseYourLevelText.alpha.animate(0, 1, 0.5);
		screenEntity.addChild(new Entity().add(chooseYourLevelText));
		
		for (ii in 0...3) {
			var levelEntity: Entity = new Entity();
			var levelBG: ImageSprite = new ImageSprite(GameManager.current.buttonDefaultTexture);
			levelBG.centerAnchor();
			
			screenDisposer.add(levelBG.pointerIn.connect(function(event: PointerEvent) {					
				levelBG.texture = GameManager.current.buttonHoverTexture;
			}));
			
			screenDisposer.add(levelBG.pointerOut.connect(function(event: PointerEvent) {
				levelBG.texture = GameManager.current.buttonDefaultTexture;
			}));
			
			screenDisposer.add(levelBG.pointerDown.connect(function(event: PointerEvent) {
				levelBG.texture = GameManager.current.buttonActiveTexture;
			}));
			
			screenDisposer.add(levelBG.pointerUp.connect(function(event: PointerEvent) {
				levelBG.texture = GameManager.current.buttonDefaultTexture;
				SceneManager.current.ShowGameScreen(true);
				SceneManager.current.ShowGameDelayScreen(false);
				SceneManager.current.gameGameScreen.InitializeSnake(ii);		
			}));
			
			levelEntity.add(levelBG);
			
			var levelFont: Font = new Font(gameAssets, AssetName.FONT_UNCERTAIN_SANS_32b);
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
			
			levelBG.alpha.animate(0, 1, (ii + 1) * 0.4);
			levelBG.y.animate(0, System.stage.height * 0.3 + ((ii + 1) * 60), (ii + 1) * 0.4, Ease.elasticInOut);
			
			levelEntity.addChild(new Entity().add(levelText));
			
			screenEntity.addChild(levelEntity);
		}
		
		screenDisposer.add(screenEntity);
		screenDisposer.add(screenScene);
		
		return screenEntity;
	}
	
	public function SetBackgroundColor(color: Int): Void {
		screenBackground.color = color;
	}
	
	public function GetScreenName(): String {
		return ScreenName.SCREEN_CHOOSE_YOUR_LEVEL;
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