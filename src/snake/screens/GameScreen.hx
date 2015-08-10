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

import snake.GridID;
import snake.SnakeGrid;

import snake.screens.SceneManager;
import snake.screens.IScreen;
import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
enum SnakeDirection {
	Right;
	Left;
	Up;
	Down;
}
 
class GameScreen extends Component implements IScreen
{
	public var screenName(default, null): String = "Game Screen";
	public var screenScene(default, null): Entity;
	public var screenDisposer(default, null): Disposer;
	
	private var sceneManager: SceneManager;
	private var gameGrid: Array<SnakeGrid>;
	private var blockedGrids = [ { x:0, y:0 }, { x:1, y:0 }, { x:2, y:0 }, { x:3, y:0 }, { x:4, y:0 }, 
								 { x:6, y:0 }, { x:7, y:0 }, { x:8, y:0 }, { x:9, y:0 }, { x:10, y:0 },
								 { x:10, y:0 }, { x:10, y:1 }, { x:10, y:2 }, { x:10, y:3 }, { x:10, y:4 }, 
								 { x:10, y:6 }, { x:10, y:7 }, { x:10, y:8 }, { x:10, y:9 }, { x:10, y:10 },
								 { x:0, y:10 }, { x:1, y:10 }, { x:2, y:10 }, { x:3, y:10 }, { x:4, y:10 }, 
								 { x:6, y:10 }, { x:7, y:10 }, { x:8, y:10 }, { x:9, y:10 }, { x:10, y:10 },
								 { x:0, y:0 }, { x:0, y:1 }, { x:0, y:2 }, { x:0, y:3 }, { x:0, y:4 }, 
								 { x:0, y:6 }, { x:0, y:7 }, { x:0, y:8 }, { x:0, y:9 }, { x:0, y:10 },
								];
	
	//private var passableGrids = [ { x:5, y: -1 }, { x:5, y: 11 }, { x: -1, y:5 }, { x:11, y:5 } ];
	
	private var snakeHead: SnakeGrid;
	private var snakeTail: SnakeGrid;
	private var snakeBody: Array<SnakeGrid>;
	
	private var snakeDirection: SnakeDirection;
	
	private static inline var SNAKE_LENGTH = 5;
	private static inline var SNAKE_COLOR = 0xFFDF32;
								
	private static inline var GRID_ROWS = 11;
	private static inline var GRID_COLUMNS = 11;
	private static inline var GRID_SPACING = 40;
	
	public function new () { }
	
	public function Initialize(manager: SceneManager): Entity {
		sceneManager = manager;
		
		screenScene = new Entity();
		screenScene.add(this);
		
		var background: FillSprite = new FillSprite(0x000000, System.stage.width, System.stage.height);
		screenScene.addChild(new Entity().add(background));
		
		InitializeGame();
		
		//System.pointer.down.connect(function(event: PointerEvent) {
			//manager.ShowGameDelayScreen(false);
		//});
		
		return screenScene;
	}
	
	public function InitializeGame(): Void {	
		gameGrid = new Array<SnakeGrid>();
		for (ii in 0...GRID_ROWS) {
			for(jj in 0...GRID_COLUMNS) {
				var snakeGrid: SnakeGrid = new SnakeGrid();
				snakeGrid.Initialize();
				snakeGrid.SetID(ii, jj);
				snakeGrid.SetXY(ii * GRID_SPACING, jj * GRID_SPACING);
				screenScene.addChild(new Entity().add(snakeGrid));
				gameGrid.push(snakeGrid);
			}
		}
		
		for (ii in 0...blockedGrids.length) {
			var snakeGrid = GetSnakeGrid(blockedGrids[ii].x, blockedGrids[ii].y);
			if (snakeGrid == null) { 
				continue; 			
			}
			snakeGrid.SetIsBlocked(true);
		}
		
		snakeBody = new Array<SnakeGrid>();
		var ii: Int = SNAKE_LENGTH;
		while (ii > 0) {
			var body: SnakeGrid = GetSnakeGrid(ii, 1);
			body.SetIsBlocked(true, SNAKE_COLOR);
			snakeBody.push(body);
			ii--;
		}
		
		snakeHead = snakeBody[0];
		snakeTail = snakeBody[snakeBody.length - 1];
		snakeDirection = SnakeDirection.Right;
		
		var script: Script = new Script();
		script.run(new Repeat(
			new Sequence([
				new CallFunction(function() {
					SnakeMove(snakeDirection);
				}),
				new Delay(0.5)
			])
		));
		
		screenScene.add(script);
		
		System.keyboard.down.connect(function(event: KeyboardEvent) {
			if (event.key == Key.Right) {
				snakeDirection = SnakeDirection.Right;
			}
			
			if (event.key == Key.Left) {
				snakeDirection = SnakeDirection.Left;
			}
			
			if (event.key == Key.Up) {
				snakeDirection = SnakeDirection.Up;
			}
			
			if (event.key == Key.Down) {
				snakeDirection = SnakeDirection.Down;
			}
			
			if (event.key == Key.Space) {
				AddSnake();
			}
		});
	}
	
	public function SnakeMove(direction: SnakeDirection): Void {	
		var nextGridID: GridID = GetSnakeNextGridID(direction);
		//Utils.ConsoleLog(nextGridID.ToString() + " " + snakeHead.id.ToString());
		var nextGrid = GetSnakeGrid(nextGridID.x, nextGridID.y);
		if (nextGrid.isBlocked) {
			Utils.ConsoleLog("BLOCKED!");
			
			var worldSpeed = new SpeedAdjuster(0.5);
			screenScene.add(worldSpeed);
			
			var script = new Script();
			script.run(new Sequence([
				new AnimateTo(worldSpeed.scale, 0, 1.5),
				new CallFunction(function() {
					sceneManager.ShowGameOverScreen(false);
					//Utils.ConsoleLog("ASD");
					
				})
			]));
			
			screenScene.add(script);
			return;
		}
		
		snakeTail.SetIsBlocked(false);
		snakeBody.remove(snakeTail);
		snakeTail = snakeBody[snakeBody.length - 1];
		
		nextGrid.SetIsBlocked(true, SNAKE_COLOR);
		snakeBody.insert(0, nextGrid);
		snakeHead = nextGrid;
		
	}
	
	public function GetSnakeNextGridID(direction: SnakeDirection): GridID {
		var result: GridID = new GridID(snakeHead.id.x, snakeHead.id.y);
		
		if (direction == SnakeDirection.Right) {
			result.x++;
			
			if (result.x == GRID_ROWS) {
				result.x = 0;
			}
		}
		
		if (direction == SnakeDirection.Left) {
			result.x--;
			
			if (result.x == -1) {
				result.x = GRID_ROWS - 1;
			}
		}
		
		if (direction == SnakeDirection.Up) {
			result.y--;
			
			if (result.y == -1) {
				result.y = GRID_COLUMNS - 1;
			}
		}
		
		if (direction == SnakeDirection.Down) {
			result.y++;
			
			if (result.y == GRID_COLUMNS) {
				result.y = 0;
			}
		}
		
		return result;
	}
	
	public function AddSnake(): Void {
		var prevGrid: SnakeGrid = GetSnakeGrid(snakeTail.id.x - 1, snakeTail.id.y);
		if (prevGrid.isBlocked) {
			prevGrid = GetSnakeGrid(snakeTail.id.x, snakeTail.id.y + 1);
		}
		
		prevGrid.SetIsBlocked(true, SNAKE_COLOR);
		snakeBody.push(prevGrid);
		snakeTail = prevGrid;
	}
	
	public function GetSnakeGrid(x: Int, y: Int): SnakeGrid {	
		var result: SnakeGrid = null;
		
		for (grid in gameGrid) {
			if (grid.id.Equals(x, y)) {
				result = grid;
			}
		}
		
		return result;
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
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
	}
	
	override public function dispose() 
	{
		super.dispose();
		Utils.ConsoleLog(screenName + " DISPOSED!");
		screenDisposer.dispose();
	}
}