package snake.core;

import flambe.System;
import flambe.animation.Ease;
import flambe.scene.SlideTransition;
import flambe.scene.FadeTransition;
import flambe.math.FMath;
import flambe.display.Sprite;
import flambe.display.FillSprite;
import flambe.display.Orientation;

import snake.screens.GameOverScreen;
import snake.screens.ChooseYourLevelScreen;
import snake.screens.GameDelayScreen;
import snake.screens.GameScreen;
import snake.screens.TitleScreen;
import snake.screens.IScreen;

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
	
	private var screenList: Array<IScreen>;
	
	public static var current: SceneManager;
	
	public static inline var GAME_WAITING_TIME: Int = 3;
	public static inline var SCENE_DEFAULT_BG: 	Int = 0x202020;
	
	public static inline var TARGET_WIDTH: 	Int = 480;
	public static inline var TARGET_HEIGHT: Int = 800;
	
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
		
		screenList = new Array<IScreen>();
		screenList.push(gameTitleScreen);
		screenList.push(gameChooseYourLevelScreen);
		screenList.push(gameGameScreen);
		screenList.push(gameGameOverScreen);
		screenList.push(gameDelayScreen);
		
		System.stage.resize.connect(function() {
			var targetWidth: 	Int = TARGET_WIDTH;
			var targetHeight: 	Int = TARGET_HEIGHT;
			
			var scale = FMath.min(System.stage.width / targetWidth, System.stage.height / targetHeight);
			if (scale > 1) scale = 1;
			
			for (screen in screenList) {
				screen.screenEntity.get(Sprite).setScale(scale).setXY(
					(System.stage.width - targetWidth * scale) / 2, 
					(System.stage.height - targetHeight * scale) / 2
				);
				
				screen.screenEntity.get(FillSprite).setScale(scale).setXY(
					(System.stage.width - targetWidth * scale) / 2, 
					(System.stage.height - targetHeight * scale) / 2
				);
			}
		});
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