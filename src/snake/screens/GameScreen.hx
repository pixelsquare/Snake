package snake.screens;

import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.scene.Scene;
import flambe.System;

import snake.core.GameManager;
import snake.core.SceneManager;
import snake.FoodSpawner;
import snake.pxlSq.Utils;
import snake.screens.IScreen;
import snake.SnakeNode;
import snake.utils.AssetName;
import snake.utils.ScreenName;
import snake.utils.NodeName;

import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
 
class GameScreen extends Component implements IScreen
{
	public var screenBackground		(default, null): FillSprite;
	public var screenScene			(default, null): Scene;
	public var screenEntity			(default, null) : Entity;
	public var screenDisposer		(default, null): Disposer;
	
	public var snakeGame			(default, null): SnakeGame;
	
	private var scoreText: 		TextSprite;
	private var scoreNumText:	TextSprite;							
	
	public static var gameGrid: Array<SnakeNode>;
	
	public static inline var GRID_ROWS: 	Int = 35;
	public static inline var GRID_COLUMNS: 	Int = 35;
	public static inline var GRID_SPACING: 	Int = 12;
	
	public function new () { }
	
	public function ScreenEntity(): Entity {	
		screenScene = new Scene();
		screenEntity = new Entity();
		
		screenEntity.add(this);
		screenEntity.add(screenScene);
		
		var gameAssets: AssetPack = GameManager.current.gameAssets;
		
		screenBackground = new FillSprite(SceneManager.SCENE_DEFAULT_BG, System.stage.width, System.stage.height);
		screenEntity.addChild(new Entity().add(screenBackground));
		
		var scoreFont: Font = new Font(gameAssets, AssetName.FONT_ARIAL_32);
		scoreText = new TextSprite(scoreFont, "SCORE");
		scoreText.centerAnchor();
		scoreText.setXY(
			System.stage.width * 0.875,
			System.stage.height * 0.4
		);
		screenEntity.addChild(new Entity().add(scoreText));
		
		var scoreNumFont:Font = new Font(gameAssets, AssetName.FONT_ARIAL_32);
		scoreNumText = new TextSprite(scoreNumFont, "");
		scoreNumText.setXY(
			scoreText.x._ - (scoreNumText.getNaturalWidth() / 2),
			scoreText.y._ + (scoreNumText.getNaturalHeight() / 2)
		);
		screenEntity.addChild(new Entity().add(scoreNumText));
		
		SetupGameGrid();
		GameManager.current.ResetScore();
		SetScoreTextDirty();
		
		screenDisposer.add(screenEntity);
		screenDisposer.add(screenScene);
		
		return screenEntity;
	}
	
	public function SetupGameGrid(): Void {		
		gameGrid = new Array<SnakeNode>();
		for(yy in 0...GRID_COLUMNS) {
			for (xx in 0...GRID_ROWS) {
				var snakeGrid: SnakeNode = new SnakeNode();
				snakeGrid.Initialize();
				snakeGrid.SetGridAddress(xx, yy);
				snakeGrid.SetIsBlocked(false);
				snakeGrid.SetNodeNameID(NodeName.NODE_GRID);
				
				var totalWidth: Float = snakeGrid.width._ * GRID_ROWS;
				var totalHeight: Float = snakeGrid.height._ * GRID_COLUMNS;
				
				snakeGrid.SetXY(
					(System.stage.width * 0.375 - (totalWidth / 2)) + xx * GRID_SPACING,
					(System.stage.height * 0.5 - (totalHeight / 2)) + yy * GRID_SPACING
				);
				
				screenEntity.addChild(new Entity().add(snakeGrid));
				gameGrid.push(snakeGrid);
			}
		}
		
		// Setup grid walls
		for (ii in 0...GRID_ROWS) {
			if (ii == ((GRID_ROWS -1) / 2)) {
				continue;
			}
			gameGrid[ii].SetIsBlocked(true);
			gameGrid[ii].SetNodeType(NodeType.Wall);
			gameGrid[ii].SetNodeNameID(NodeName.NODE_GRID_BLOCKER);
			
			var leftIndx: Int = ii * GRID_ROWS;
			gameGrid[leftIndx].SetIsBlocked(true);
			gameGrid[leftIndx].SetNodeType(NodeType.Wall);
			gameGrid[leftIndx].SetNodeNameID(NodeName.NODE_GRID_BLOCKER);
			
			var rightIndx: Int = ii * GRID_ROWS + (GRID_ROWS - 1);
			gameGrid[rightIndx].SetIsBlocked(true);
			gameGrid[rightIndx].SetNodeType(NodeType.Wall);
			gameGrid[rightIndx].SetNodeNameID(NodeName.NODE_GRID_BLOCKER);
			
			var bottomIndx: Int = ((GRID_ROWS * GRID_COLUMNS) - GRID_ROWS) + ii;
			gameGrid[bottomIndx].SetIsBlocked(true);
			gameGrid[bottomIndx].SetNodeType(NodeType.Wall);
			gameGrid[bottomIndx].SetNodeNameID(NodeName.NODE_GRID_BLOCKER);
		}
	}
	
	public function InitializeSnake(id: Int): Void {
		snakeGame = new snake.SnakeGame();
		
		if (id == 0) {
			snakeGame.SetSnakeSpeed(0.5);
		}
		else if (id == 1) {
			snakeGame.SetSnakeSpeed(0.25);
		}
		else if (id == 2) {
			snakeGame.SetSnakeSpeed(0.1);
		}
		
		// Add foodspawner
		var foodSpawner: FoodSpawner = new FoodSpawner();
		foodSpawner.Create(0xFFD700, 1, 0.1, 1);
		
		snakeGame.onCollide = function(node: SnakeNode) {
			if (node.nodeType == NodeType.Wall) {
				Utils.ConsoleLog("WALL!");
			}
			
			if (node.nodeType == NodeType.Food) {
				Utils.ConsoleLog("FOOD!");			
				// Remove if the node is comming from the spawner
				if (node.nodeNameId == snakeGame.snakeEntity.get(FoodSpawner).GetNodeName()) {
					foodSpawner.SubtractFoodCount();
					AddScore();
				}
			}
		};
		
		snakeGame.Initialize([ foodSpawner ]);
		screenEntity.add(snakeGame);
	}
	
	public function AddScore(amt: Int = 1): Void {
		GameManager.current.AddGameScore(amt);
		SetScoreTextDirty();
	}
	
	public function SetScoreTextDirty(): Void {
		scoreNumText.text = GameManager.current.gameScore + "";
		scoreNumText.setXY(
			scoreText.x._ - (scoreNumText.getNaturalWidth() / 2),
			scoreText.y._ + (scoreNumText.getNaturalHeight() / 2)
		);
	}
	
	public function SetBackgroundColor(color: Int): Void {
		screenBackground.color = color;
	}
	
	public function GetScreenName(): String {
		return ScreenName.SCREEN_GAME_MAIN;
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