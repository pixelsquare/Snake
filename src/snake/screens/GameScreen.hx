package snake.screens;

import flambe.Component;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.math.Point;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.SpeedAdjuster;
import flambe.System;
import flambe.input.PointerEvent;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.display.Font;
import flambe.Disposer;
import flambe.input.Key;
import snake.utils.AssetName;

import snake.GridID;
import snake.SnakeNode;

import snake.screens.SceneManager;
import snake.screens.IScreen;
import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameScreen extends Component implements IScreen
{
	public var screenName(default, null): String = "Game Screen";
	public var screenScene(default, null): Entity;
	public var screenDisposer(default, null): Disposer;
	
	public var snake(default, null): Snake;
	
	private var sceneManager: SceneManager;
	private var openGrids = 	[ { x:17, y:0 }, { x:0, y:17 }, { x:35, y:17 }, { x:17, y:35 } ];
	
	private var scoreText: TextSprite;
	private var scoreNumText: TextSprite;							
	
	public static var gameGrid: Array<SnakeNode>;
	
	public static inline var GRID_ROWS = 35;
	public static inline var GRID_COLUMNS = 35;
	public static inline var GRID_SPACING = 12;
	
	public function new () { }
	
	public function Initialize(manager: SceneManager): Entity {
		sceneManager = manager;
		
		screenScene = new Entity();
		screenScene.add(this);
		
		var background: FillSprite = new FillSprite(0x202020, System.stage.width, System.stage.height);
		screenScene.addChild(new Entity().add(background));
		
		var scoreFont: Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		scoreText = new TextSprite(scoreFont, "SCORE");
		scoreText.centerAnchor();
		scoreText.setXY(
			System.stage.width * 0.875,
			System.stage.height * 0.4
		);
		screenScene.addChild(new Entity().add(scoreText));
		
		var scoreNumFont:Font = new Font(manager.gameAssets, AssetName.FONT_ARIAL_32);
		scoreNumText = new TextSprite(scoreNumFont, "");
		scoreNumText.setXY(
			scoreText.x._ - (scoreNumText.getNaturalWidth() / 2),
			scoreText.y._ + (scoreNumText.getNaturalHeight() / 2)
		);
		screenScene.addChild(new Entity().add(scoreNumText));
		
		CreateGameWorld();
		SetScoreTextDirty();
		
		//System.keyboard.down.connect(function(event: KeyboardEvent) {
			//if (event.key == Key.B) {
				//AddScore();
			//}
		//});
		
		return screenScene;
	}
	
	public function CreateGameWorld(): Void {		
		gameGrid = new Array<SnakeNode>();
		for(ii in 0...GRID_COLUMNS) {
			for (jj in 0...GRID_ROWS) {
				var snakeGrid: SnakeNode = new SnakeNode();
				snakeGrid.Initialize();
				snakeGrid.SetID(jj, ii);
				
				var totalWidth: Float = snakeGrid.width._ * GRID_ROWS;
				var totalHeight: Float = snakeGrid.height._ * GRID_COLUMNS;
				
				snakeGrid.SetXY(
					(System.stage.width * 0.375 - (totalWidth / 2)) + jj * GRID_SPACING,
					(System.stage.height * 0.425 - (totalHeight / 2)) + ii * GRID_SPACING
				);
				
				screenScene.addChild(new Entity().add(snakeGrid));
				gameGrid.push(snakeGrid);
			}
		}
		
		for (ii in 0...GRID_ROWS) {
			if (ii == ((GRID_ROWS -1) / 2)) {
				continue;
			}
			gameGrid[ii].SetIsBlocked(true);
			
			var leftIndx: Int = ii * GRID_ROWS;
			gameGrid[leftIndx].SetIsBlocked(true);
			
			var rightIndx: Int = ii * GRID_ROWS + (GRID_ROWS - 1);
			gameGrid[rightIndx].SetIsBlocked(true);
			
			var bottomIndx: Int = ((GRID_ROWS * GRID_COLUMNS) - GRID_ROWS) + ii;
			gameGrid[bottomIndx].SetIsBlocked(true);
		}
		
		//Utils.ConsoleLog(gameGrid.length + "");
	}
	
	public function InitializeSnake(id: Int): Void {
		snake = new snake.Snake();
		snake.onCollide = function() {
			Utils.ConsoleLog("Game Over!");
			sceneManager.ShowGameOverScreen(false);
		};
		
		screenScene.add(snake);
		
		if (id == 0) {
			snake.SetSpeed(0.5);
		}
		else if (id == 1) {
			snake.SetSpeed(0.25);
		}
		else if (id == 2) {
			snake.SetSpeed(0.1);
		}
		
		snake.Initialize();
	}
	
	public function AddScore(amt: Int = 1): Void {
		sceneManager.gameScore++;
		SetScoreTextDirty();
	}
	
	public function SetScoreTextDirty(): Void {
		scoreNumText.text = sceneManager.gameScore + "";
		scoreNumText.setXY(
			scoreText.x._ - (scoreNumText.getNaturalWidth() / 2),
			scoreText.y._ + (scoreNumText.getNaturalHeight() / 2)
		);
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