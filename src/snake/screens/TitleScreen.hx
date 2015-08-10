package snake.screens;

import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.System;
import flambe.util.SignalConnection;
import flambe.Disposer;
import snake.utils.AssetName;

import snake.screens.SceneManager;
import snake.screens.IScreen;
import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class TitleScreen extends Component implements IScreen
{	
	public var screenName(default, null): String = "Title Screen";
	public var screenScene(default, null): Entity;
	public var screenDisposer(default, null): Disposer;
	
	public function new () { }
	
	public function Initialize(manager: SceneManager): Entity {
		screenScene = new Entity();
		screenScene.add(this);
		
		var background: FillSprite = new FillSprite(0x202020, System.stage.width, System.stage.height);	
		screenScene.addChild(new Entity().add(background));
		
		// Title text
		var titleFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var titleText: TextSprite = new TextSprite(titleFont, "SNaKE");
		titleText.centerAnchor();
		titleText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.4
		);
		screenScene.addChild(new Entity().add(titleText));
		
		// Click anywhere to start text
		var clickToStartFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var clickToStartText: TextSprite = new TextSprite(clickToStartFont, "Click anywhere to Start!");
		clickToStartText.centerAnchor();
		clickToStartText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.6
		);
		screenScene.addChild(new Entity().add(clickToStartText));
		
		// Highscore text
		var highScoreFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var highScoreText: TextSprite = new TextSprite(highScoreFont, "High Score");
		highScoreText.centerAnchor();
		highScoreText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.8
		);
		screenScene.addChild(new Entity().add(highScoreText));
		
		// Score Text
		var scoreFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var scoreText: TextSprite = new TextSprite(scoreFont, "00000");
		scoreText.setXY(
			highScoreText.x._ - (scoreText.getNaturalWidth() / 2),
			highScoreText.y._ + (scoreText.getNaturalHeight() / 2)
		);
		screenScene.addChild(new Entity().add(scoreText));
		
		screenDisposer.add(System.pointer.down.connect(function(event: PointerEvent) {
			manager.ShowChooseYourLevelScreen(true);
		}));
		
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