package snake;

import flambe.asset.AssetPack;
import flambe.scene.Director;
import flambe.animation.Ease;
import flambe.scene.SlideTransition;
import flambe.subsystem.StorageSystem;
import flambe.display.Texture;

import snake.TitleScreen;
import snake.ChooseYourLevelScreen;
import snake.GameScreen;
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
	
	public var buttonDefaultTexture(default, null): Texture;
	public var buttonHoverTexture(default, null): Texture;
	public var buttonActiveTexture(default, null): Texture;
	
	public function new() { }
	
	public function Initialize(pack: AssetPack, director: Director, storage: StorageSystem): Void {
		gameAssets = pack;
		gameDirector = director;
		gameStorage = storage;
		
		buttonDefaultTexture = gameAssets.getTexture(AssetName.BUTTON_GREY_1);
		buttonHoverTexture = gameAssets.getTexture(AssetName.BUTTON_GREY_5);
		buttonActiveTexture = gameAssets.getTexture(AssetName.BUTTON_GREY_3);
	}
	
	public function ShowTitleScreen(animate: Bool): Void {
		gameDirector.unwindToScene(new TitleScreen().Initialize(this), 
			animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowChooseYourLevelScreen(animate: Bool): Void {
		gameDirector.unwindToScene(new ChooseYourLevelScreen().Initialize(this), 
			animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowGameScreen(animate: Bool): Void {
		gameDirector.unwindToScene(new GameScreen().Initialize(this), 
			animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowGameOverScreen(animate: Bool): Void {
		gameDirector.unwindToScene(new GameOverScreen().Initialize(this),
			animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
}