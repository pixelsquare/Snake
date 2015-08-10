package snake.screens;

import flambe.asset.AssetPack;
import flambe.scene.Director;
import flambe.animation.Ease;
import flambe.scene.SlideTransition;
import flambe.subsystem.StorageSystem;
import flambe.display.Texture;
import snake.utils.AssetName;

import snake.screens.TitleScreen;
import snake.screens.ChooseYourLevelScreen;
import snake.screens.GameScreen;
import snake.pxlSq.GameOverScreen;

/**
 * ...
 * @author Anthony Ganzon
 */
class SceneManager
{

	public var gameAssets(default, null): AssetPack;
	
	public var gameDirector(default, null): Director;
	
	public var gameStorage(default, null): StorageSystem;
	
	public var gameScore(default, null): Int;
	
	public var buttonDefaultTexture(default, null): Texture;
	public var buttonHoverTexture(default, null): Texture;
	public var buttonActiveTexture(default, null): Texture;
	
	public var gameTitleScreen(default, null): TitleScreen;
	public var gameChooseYourLevelScreen(default, null): ChooseYourLevelScreen;
	public var gameGameScreen(default, null): GameScreen;
	public var gameGameOverScreen(default, null): GameOverScreen;
	public var gameDelayScreen(default, null): GameDelayScreen;
	
	public static inline var GAME_DELAY = 3;
	
	public function new() { }
	
	public function Initialize(pack: AssetPack, director: Director, storage: StorageSystem): Void {
		gameAssets = pack;
		gameDirector = director;
		gameStorage = storage;
		gameScore = 0;
		
		buttonDefaultTexture = gameAssets.getTexture(AssetName.BUTTON_GREY_1);
		buttonHoverTexture = gameAssets.getTexture(AssetName.BUTTON_GREY_5);
		buttonActiveTexture = gameAssets.getTexture(AssetName.BUTTON_GREY_3);
		
		gameTitleScreen = new TitleScreen();
		gameChooseYourLevelScreen = new ChooseYourLevelScreen();
		gameGameScreen = new GameScreen();
		gameGameOverScreen = new GameOverScreen();
		gameDelayScreen = new GameDelayScreen();
	}
	
	public function ShowTitleScreen(animate: Bool): Void {
		gameDirector.unwindToScene(gameTitleScreen.Initialize(this), 
			animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowChooseYourLevelScreen(animate: Bool): Void {
		gameDirector.unwindToScene(gameChooseYourLevelScreen.Initialize(this), 
			animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowGameScreen(animate: Bool): Void {
		gameDirector.unwindToScene(gameGameScreen.Initialize(this), 
			animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowGameOverScreen(animate: Bool): Void {
		gameDirector.pushScene(gameGameOverScreen.Initialize(this));
		//gameDirector.unwindToScene(gameGameOverScreen.Initialize(this),
			//animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowGameDelayScreen(animate: Bool): Void {
		gameDirector.pushScene(gameDelayScreen.Initialize(this));
		//gameDirector.unwindToScene(new GameDelayScreen().Initialize(this),
			//animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
}