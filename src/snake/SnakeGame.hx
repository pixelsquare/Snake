package snake;

import flambe.Component;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.SpeedAdjuster;
import flambe.System;

import snake.core.GameManager;
import snake.core.SceneManager;
import snake.GridAddress;
import snake.pxlSq.Utils;
import snake.screens.GameScreen;
import snake.SnakeNode.NodeType;

import snake.pxlSq.Utils;

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

class SnakeGame extends Component
{
	public var snakeSpeed		(default, null): Float;
	public var onCollide: 		SnakeNode -> Void;
	public var snakeEntity		(default, null): 	Entity;
	
	private var snakeDisposer: 	Disposer;
	
	private var snakeHead: 		SnakeNode;
	private var snakeTail: 		SnakeNode;
	private var snakeBody: 		Array<SnakeNode>;
	
	private var snakeDirection: SnakeDirection;
	
	private static inline var DEFAULT_SPEED = 0.5;
	private static inline var SNAKE_LENGTH = 5;
	private static inline var SNAKE_COLOR = 0xFFFFFF;
	
	public function new() 
	{
		snakeSpeed = DEFAULT_SPEED;
		onCollide = null;
		
		snakeHead = null;
		snakeTail = null;
		snakeBody = null;
		
		snakeDirection = SnakeDirection.Right;
		
		CreateSnake();
	}
	
	public function Initialize(foodSpawners: Array<FoodSpawner>): Void {
		snakeEntity = new Entity();
		snakeDisposer = new Disposer();
		
		snakeDisposer.add(System.keyboard.down.connect(function(event: KeyboardEvent) {
			if (event.key == Key.Right) {
				if (snakeDirection == SnakeDirection.Left) 
					return;
					
				snakeDirection = SnakeDirection.Right;
			}
			
			if (event.key == Key.Left) {
				if (snakeDirection == SnakeDirection.Right) 
					return;
				
				snakeDirection = SnakeDirection.Left;
			}
			
			if (event.key == Key.Up) {
				if (snakeDirection == SnakeDirection.Down) 
					return;
				
				snakeDirection = SnakeDirection.Up;
			}
			
			if (event.key == Key.Down) {
				if (snakeDirection == SnakeDirection.Up) 
					return;
				
				snakeDirection = SnakeDirection.Down;
			}
		}));
		
		var script: Script = new Script();
		script.run(new Repeat(
			new Sequence([
				new CallFunction(function() {
					SnakeMove(snakeDirection);
				}),
				new Delay(snakeSpeed)
			])
		));
		
		snakeEntity.add(script);
		snakeDisposer.add(script);
		
		for (spawner in foodSpawners) {
			spawner.Run();
			snakeEntity.add(spawner);
		}
		
		snakeDisposer.add(snakeEntity);
	}
	
	private function CreateSnake(): Void {
		snakeBody = new Array<SnakeNode>();
		var ii: Int = SNAKE_LENGTH;
		while (ii > 0) {
			var body: SnakeNode = Utils.GetGridNode(ii, 1);
			body.SetIsBlocked(true, SNAKE_COLOR);
			body.SetNewDirection(new GridAddress(1, 0));
			body.SetNodeType(NodeType.Wall);
			snakeBody.push(body);
			ii--;
		}
		
		snakeHead = snakeBody[0];
		snakeTail = snakeBody[snakeBody.length - 1];
	}
	
	public function SnakeMove(direction: SnakeDirection): Void {	
		// Locate next grid position
		var nextGridAddress: GridAddress = GetSnakeNextGridID(direction);
		var nextGrid = Utils.GetGridNode(nextGridAddress.x, nextGridAddress.y);
		
		if (nextGrid.isBlocked) {	
			if (onCollide != null) {
				onCollide(nextGrid);
			}
			
			if (nextGrid.nodeType == NodeType.Food) {
				nextGrid.SetIsBlocked(false);
				AddSnake();
			}
			
			if(nextGrid.nodeType == NodeType.Wall) {
				var worldSpeed = new SpeedAdjuster(0.5);
				snakeEntity.add(worldSpeed);
				
				var script = new Script();
				script.run(new Sequence([
					new AnimateTo(worldSpeed.scale, 0, 0.1),
					new CallFunction(function() {
						Utils.ConsoleLog("Game Over!");
						SceneManager.current.ShowGameOverScreen(false);
						GameManager.current.SetGameHighScore(GameManager.current.gameScore);
					})
				]));
				
				snakeEntity.add(script);
				return;
			}
		}
		
		var adjacentGrid: SnakeNode = Utils.GetGridNode(snakeBody[snakeBody.length - 2].gridAddress.x, snakeBody[snakeBody.length - 2].gridAddress.y);
		var direction: GridAddress = new GridAddress(
			adjacentGrid.gridAddress.x - snakeTail.gridAddress.x,
			adjacentGrid.gridAddress.y - snakeTail.gridAddress.y
		);
		
		snakeTail.SetIsBlocked(false);
		snakeTail.SetNodeType(NodeType.None);
		snakeBody.remove(snakeTail);
		snakeTail = snakeBody[snakeBody.length - 1];
		snakeTail.SetNewDirection(direction);
		
		nextGrid.SetIsBlocked(true, SNAKE_COLOR);
		snakeBody.insert(0, nextGrid);
		snakeHead = nextGrid;
		snakeHead.SetNodeType(NodeType.Wall);
		snakeHead.SetNewDirection(Utils.GetGridDirection(snakeDirection));
	}
	
	public function GetSnakeNextGridID(direction: SnakeDirection): GridAddress {
		var result: GridAddress = new GridAddress(snakeHead.gridAddress.x, snakeHead.gridAddress.y);
		
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
		// Take the direction of the adjacent node to the tail node
		var adjacentGrid: SnakeNode = Utils.GetGridNode(snakeBody[snakeBody.length - 2].gridAddress.x, snakeBody[snakeBody.length - 2].gridAddress.y);
		var direction: GridAddress = new GridAddress(
			adjacentGrid.gridAddress.x - snakeTail.gridAddress.x,
			adjacentGrid.gridAddress.y - snakeTail.gridAddress.y
		);
		
		// Add the tail adjacent next to the current tail
		var prevGrid: SnakeNode = Utils.GetGridNode(snakeTail.gridAddress.x - direction.x, snakeTail.gridAddress.y - direction.y);
		
		// If the node is blocked. Take the last grid address (direction) of the tail node.
		if (prevGrid.isBlocked) {
			prevGrid = Utils.GetGridNode(snakeTail.gridAddress.x - snakeTail.oldDirection.x, snakeTail.gridAddress.y - snakeTail.oldDirection.y);
		}
		
		prevGrid.SetIsBlocked(true, SNAKE_COLOR);
		snakeBody.push(prevGrid);
		snakeTail = prevGrid;
	}
	
	public function SetSnakeSpeed(speed: Float): Void {
		snakeSpeed = speed;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		owner.addChild(snakeEntity);
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