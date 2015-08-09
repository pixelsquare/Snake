package snake;

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

import snake.SceneManager;
import snake.IScreen;
import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class TitleScreen extends Component implements IScreen
{	
	public var screenDisposer(default, null): Disposer;
	private var signalConnection: SignalConnection;
	
	public function new () { }
	
	public function Initialize(manager: SceneManager): Entity {
		var scene: Entity = new Entity();
		scene.add(this);
		
		var background: FillSprite = new FillSprite(0x202020, System.stage.width, System.stage.height);	
		scene.addChild(new Entity().add(background));
		
		// Title text
		var titleFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var titleText: TextSprite = new TextSprite(titleFont, "SNaKE");
		titleText.centerAnchor();
		titleText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.4
		);
		scene.addChild(new Entity().add(titleText));
		
		// Click anywhere to start text
		var clickToStartFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var clickToStartText: TextSprite = new TextSprite(clickToStartFont, "Click anywhere to Start!");
		clickToStartText.centerAnchor();
		clickToStartText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.6
		);
		scene.addChild(new Entity().add(clickToStartText));
		
		// Highscore text
		var highScoreFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var highScoreText: TextSprite = new TextSprite(highScoreFont, "High Score");
		highScoreText.centerAnchor();
		highScoreText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.8
		);
		scene.addChild(new Entity().add(highScoreText));
		
		// Score Text
		var scoreFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		var scoreText: TextSprite = new TextSprite(scoreFont, "00000");
		scoreText.setXY(
			highScoreText.x._ - (scoreText.getNaturalWidth() / 2),
			highScoreText.y._ + (scoreText.getNaturalHeight() / 2)
		);
		scene.addChild(new Entity().add(scoreText));
		
		signalConnection = System.pointer.down.connect(function(event: PointerEvent) {
			manager.ShowChooseYourLevelScreen(true);
		});
		signalConnection.once();
		
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
		signalConnection.dispose();
	}
	
	override public function dispose() 
	{
		super.dispose();
		Utils.ConsoleLog("DISPOSED!");
		screenDisposer.dispose();
	}
}