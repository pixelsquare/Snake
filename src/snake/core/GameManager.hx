package snake.core;

import flambe.display.Texture;

import snake.core.SceneManager;
import snake.utils.AssetName;
import snake.utils.DataName;

import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameManager extends SceneManager
{
	public var gameScore		(default, null): Int;
	public var gameHighScore	(default, null): Int;
	
	public var buttonDefaultTexture		(default, null): Texture;
	public var buttonHoverTexture		(default, null): Texture;
	public var buttonActiveTexture		(default, null): Texture;
	
	public static var current: GameManager;
	
	public function new()  {
		super();
		current = this;
	}
	
	override public function Initialize():Void {
		buttonDefaultTexture = gameAssets.getTexture(AssetName.BUTTON_GREY_1);
		buttonHoverTexture 	 = gameAssets.getTexture(AssetName.BUTTON_GREY_5);
		buttonActiveTexture  = gameAssets.getTexture(AssetName.BUTTON_GREY_3);
		
		gameHighScore = gameStorage.get(DataName.GAME_SCORE, 0);
		
		super.Initialize();
	}
	
	public function SetGameScore(score: Int): Void {
		gameScore = score;
	}
	
	public function AddGameScore(score: Int = 1): Void {
		gameScore += score;
	}
	
	public function SetGameHighScore(score: Int): Void {
		if (score < gameHighScore)
			return;
		
		gameHighScore = score;
		gameStorage.set(DataName.GAME_SCORE, gameHighScore);
	}
	
	public function ResetScore(): Void {
		gameScore = 0;
	}
	
	public function ResetHighestScore(): Void {
		gameHighScore = 0;
		gameTitleScreen.SetHighScoreDirty();
		gameStorage.set(DataName.GAME_SCORE, gameHighScore);
	}
}