package snake;

import flambe.Component;
import flambe.Disposer;
import flambe.Entity;
import flambe.script.Script;
import flambe.System;
import flambe.SpeedAdjuster;
import flambe.script.Repeat;
import flambe.input.KeyboardEvent;
import flambe.script.Sequence;
import flambe.script.CallFunction;
import flambe.input.Key;
import flambe.script.AnimateTo;
import flambe.script.Delay;

import snake.pxlSq.Utils;
import snake.GridID;
import snake.screens.GameScreen;

/**
 * ...
 * @author Anthony Ganzon
 */

enum SnakeDirection {
	None;
	Right;
	Left;
	Up;
	Down;
}

class Snake extends Component
{
	private var snakeScene: Entity;
	public var snakeSpeed(default, null): Float;
	public var onCollide(default, default): Dynamic; 
	
	private var snakeHead: SnakeNode;
	private var snakeTail: SnakeNode;
	private var snakeBody: Array<SnakeNode>;
	
	private var snakeDirection: SnakeDirection;
	private var snakeDisposer: Disposer;
	
	private static inline var DEFAULT_SPEED = 0.5;
	private static inline var SNAKE_LENGTH = 5;
	private static inline var SNAKE_COLOR = 0xFFDF32;
	
	public function new() 
	{
		snakeScene = new Entity();
		snakeDisposer = new Disposer();
		snakeDirection = SnakeDirection.Right;
		snakeSpeed = DEFAULT_SPEED;
		CreateSnake();
		
		snakeDisposer.add(System.keyboard.down.connect(function(event: KeyboardEvent) {
			if (event.key == Key.Right) {
				if (snakeDirection == SnakeDirection.Left) return;
				snakeDirection = SnakeDirection.Right;
			}
			
			if (event.key == Key.Left) {
				if (snakeDirection == SnakeDirection.Right) return;
				
				snakeDirection = SnakeDirection.Left;
			}
			
			if (event.key == Key.Up) {
				if (snakeDirection == SnakeDirection.Down) return;
				
				snakeDirection = SnakeDirection.Up;
			}
			
			if (event.key == Key.Down) {
				if (snakeDirection == SnakeDirection.Up) return;
				
				snakeDirection = SnakeDirection.Down;
			}
			
			//if (event.key == Key.B) {
				//AddSnake();
			//}
			
			if (event.key == Key.Space) {
				AddSnake();
			}
		}));
	}
	
	public function Initialize(): Void {
		var script: Script = new Script();
		script.run(new Repeat(
			new Sequence([
				new CallFunction(function() {
					SnakeMove(snakeDirection);
					//Utils.ConsoleLog(snakeSpeed + "");
				}),
				new Delay(snakeSpeed)
			])
		));
		
		snakeScene.add(script);
	}
	
	private function CreateSnake(): Void {
		snakeBody = new Array<SnakeNode>();
		var ii: Int = SNAKE_LENGTH;
		while (ii > 0) {
			var body: SnakeNode = Utils.GetSnakeGrid(ii, 1);
			body.SetIsBlocked(true, SNAKE_COLOR);
			body.SetNewDirection(new GridID(1, 0));
			snakeBody.push(body);
			ii--;
		}
		
		snakeHead = snakeBody[0];
		snakeTail = snakeBody[snakeBody.length - 1];
		
	}
	
	public function SnakeMove(direction: SnakeDirection): Void {	
		var nextGridID: GridID = GetSnakeNextGridID(direction);
		//Utils.ConsoleLog(nextGridID.ToString() + " " + snakeHead.id.ToString());
		var nextGrid = Utils.GetSnakeGrid(nextGridID.x, nextGridID.y);
		if (nextGrid.isBlocked) {
			Utils.ConsoleLog("BLOCKED!");
			
			var worldSpeed = new SpeedAdjuster(0.5);
			snakeScene.add(worldSpeed);
			
			var script = new Script();
			script.run(new Sequence([
				new AnimateTo(worldSpeed.scale, 0, 0.5),
				new CallFunction(function() {
					if (onCollide != null) {
						onCollide();
					}
				})
			]));
			
			snakeScene.add(script);
			return;
		}
		
		var adjacentGrid: SnakeNode = Utils.GetSnakeGrid(snakeBody[snakeBody.length - 2].id.x, snakeBody[snakeBody.length - 2].id.y);
		var direction: GridID = new GridID(
			adjacentGrid.id.x - snakeTail.id.x,
			adjacentGrid.id.y - snakeTail.id.y
		);
		
		//Utils.ConsoleLog(direction.ToString());
		
		snakeTail.SetIsBlocked(false);
		snakeBody.remove(snakeTail);
		snakeTail = snakeBody[snakeBody.length - 1];
		snakeTail.SetNewDirection(direction);
		
		nextGrid.SetIsBlocked(true, SNAKE_COLOR);
		snakeBody.insert(0, nextGrid);
		snakeHead = nextGrid;
		snakeHead.SetNewDirection(GetGridDirection(snakeDirection));
	}
	
	public function GetSnakeNextGridID(direction: SnakeDirection): GridID {
		var result: GridID = new GridID(snakeHead.id.x, snakeHead.id.y);
		
		if (direction == SnakeDirection.Right) {
			result.x++;
			
			if (result.x == GameScreen.GRID_ROWS) {
				result.x = 0;
			}
		}
		
		if (direction == SnakeDirection.Left) {
			result.x--;
			
			if (result.x == -1) {
				result.x = GameScreen.GRID_ROWS - 1;
			}
		}
		
		if (direction == SnakeDirection.Up) {
			result.y--;
			
			if (result.y == -1) {
				result.y = GameScreen.GRID_COLUMNS - 1;
			}
		}
		
		if (direction == SnakeDirection.Down) {
			result.y++;
			
			if (result.y == GameScreen.GRID_COLUMNS) {
				result.y = 0;
			}
		}
		
		return result;
	}
	
	public function AddSnake(): Void {
		var adjacentGrid: SnakeNode = Utils.GetSnakeGrid(snakeBody[snakeBody.length - 2].id.x, snakeBody[snakeBody.length - 2].id.y);
		var direction: GridID = new GridID(
			adjacentGrid.id.x - snakeTail.id.x,
			adjacentGrid.id.y - snakeTail.id.y
		);
		
		// Add the tail adjacent next to the current tail
		var prevGrid: SnakeNode = Utils.GetSnakeGrid(snakeTail.id.x - direction.x, snakeTail.id.y - direction.y);
		
		// If the node is blocked. Take the last grid address (direction) of the tail node.
		if (prevGrid.isBlocked) {
			prevGrid = Utils.GetSnakeGrid(snakeTail.id.x - snakeTail.oldDirection.x, snakeTail.id.y - snakeTail.oldDirection.y);
		}
		
		prevGrid.SetIsBlocked(true, SNAKE_COLOR);
		snakeBody.push(prevGrid);
		snakeTail = prevGrid;
	}
	
	public function SetSpeed(speed: Float): Void {
		snakeSpeed = speed;
	}
	
	public function GetGridDirection(direction: SnakeDirection): GridID {
		if (direction == SnakeDirection.Right) {
			return new GridID(1, 0);
		}
		else if (direction == SnakeDirection.Left) {
			return new GridID(-1, 0);
		}
		else if (direction == SnakeDirection.Up) {
			return new GridID(0,  1);
		}
		else if (direction == SnakeDirection.Down) {
			return new GridID(0, -1);
		}
		
		return new GridID(0, 0);
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		owner.addChild(snakeScene);
		snakeDisposer = owner.get(Disposer);
		if (snakeDisposer == null) {
			owner.add(snakeDisposer = new Disposer());
		}
	}
	
	override public function onRemoved() 
	{
		super.onRemoved();
	}
	
	override public function dispose() 
	{
		super.dispose();
		snakeDisposer.dispose();
	}
}