package snake.core;

import flambe.animation.Ease;
import flambe.scene.SlideTransition;

import snake.screens.GameOverScreen;
import snake.screens.ChooseYourLevelScreen;
import snake.screens.GameDelayScreen;
import snake.screens.GameScreen;
import snake.screens.TitleScreen;

import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class SceneManager extends Manager
{		
	public var gameTitleScreen				(default, null): TitleScreen;
	public var gameChooseYourLevelScreen	(default, null): ChooseYourLevelScreen;
	public var gameGameScreen				(default, null): GameScreen;
	public var gameGameOverScreen			(default, null): GameOverScreen;
	public var gameDelayScreen				(default, null): GameDelayScreen;
	
	public static var current: SceneManager;
	
	public static inline var GAME_WAITING_TIME: Int = 3;
	public static inline var SCENE_DEFAULT_BG: 	Int = 0x202020;
	
	public function new() { 
		super(); 
		current = this;
	}
	
	override public function Initialize(): Void 
	{		
		gameTitleScreen 			= new TitleScreen();
		gameChooseYourLevelScreen 	= new ChooseYourLevelScreen();
		gameGameScreen 				= new GameScreen();
		gameGameOverScreen 			= new GameOverScreen();
		gameDelayScreen 			= new GameDelayScreen();
	}

	//public function Initialize(pack: AssetPack, director: Director, storage: StorageSystem): Void {
		//gameAssets = pack;
		//gameDirector = director;
		//gameStorage = storage;
		//gameScore = 0;
		//
		//buttonDefaultTexture = gameAssets.getTexture(AssetName.BUTTON_GREY_1);
		//buttonHoverTexture = gameAssets.getTexture(AssetName.BUTTON_GREY_5);
		//buttonActiveTexture = gameAssets.getTexture(AssetName.BUTTON_GREY_3);
		//
		//gameTitleScreen = new TitleScreen();
		//gameChooseYourLevelScreen = new ChooseYourLevelScreen();
		//gameGameScreen = new GameScreen();
		//gameGameOverScreen = new GameOverScreen();
		//gameDelayScreen = new GameDelayScreen();
		//
		////System.stage.resize.connect(function() {
			////var targetWidth: Int = 1136;
			////var targetHeight: Int = 640;
			////
			////var scale = FMath.min(System.stage.width / targetWidth, System.stage.height / targetHeight);
			////if (scale > 1) scale = 1;
			////
			////Utils.ConsoleLog(scale + "");
			////
			////gameGameScreen.screenScene.get(FillSprite).setScale(scale).setXY(
				////(System.stage.width - targetWidth * scale) / 2, 
				////(System.stage.height - targetHeight * scale) / 2
			////);
			////
			////gameGameScreen.screenScene.get(Sprite).setScale(scale).setXY(
				////(System.stage.width - targetWidth * scale) / 2, 
				////(System.stage.height - targetHeight * scale) / 2
			////);
			////
			////gameGameScreen.screenScene.get(Sprite).scissor = new Rectangle(0, 0, targetWidth, targetHeight);
		////});
	//}
	
	//public function SetScore(amt: Int): Void {
		//gameScore = amt;
	//}
	//
	//public function AddScore(amt: Int = 1): Void {
		//gameScore += amt;
	//}
	
	public function ShowTitleScreen(animate: Bool): Void {
		gameDirector.unwindToScene(gameTitleScreen.ScreenEntity(), 
			animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowChooseYourLevelScreen(animate: Bool): Void {
		gameDirector.unwindToScene(gameChooseYourLevelScreen.ScreenEntity(), 
			animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowGameScreen(animate: Bool): Void {
		gameDirector.unwindToScene(gameGameScreen.ScreenEntity(), 
			animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowGameOverScreen(animate: Bool): Void {
		gameDirector.pushScene(gameGameOverScreen.ScreenEntity());
		//gameDirector.unwindToScene(gameGameOverScreen.Initialize(this),
			//animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowGameDelayScreen(animate: Bool): Void {
		gameDirector.pushScene(gameDelayScreen.ScreenEntity());
		//gameDirector.unwindToScene(new GameDelayScreen().Initialize(this),
			//animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
}