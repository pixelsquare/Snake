package snake.core;

import flambe.animation.Ease;
import flambe.scene.SlideTransition;
import flambe.scene.FadeTransition;

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
	
	public function ShowTitleScreen(animate: Bool): Void {
		gameDirector.unwindToScene(gameTitleScreen.ScreenEntity(), 
			animate ? new FadeTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowChooseYourLevelScreen(animate: Bool): Void {
		gameDirector.unwindToScene(gameChooseYourLevelScreen.ScreenEntity(), 
			animate ? new SlideTransition(0.5, Ease.quadOut) : null);
	}
	
	public function ShowGameScreen(animate: Bool): Void {
		gameDirector.unwindToScene(gameGameScreen.ScreenEntity(), 
			animate ? new FadeTransition(0.5, Ease.sineOut) : null);
	}
	
	public function ShowGameOverScreen(animate: Bool): Void {
		gameDirector.pushScene(gameGameOverScreen.ScreenEntity());
	}
	
	public function ShowGameDelayScreen(animate: Bool): Void {
		gameDirector.pushScene(gameDelayScreen.ScreenEntity());
	}
}