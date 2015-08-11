package snake;

import flambe.Component;
import flambe.Disposer;
import flambe.Entity;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;

import snake.screens.GameScreen;
import snake.SnakeNode.NodeType;
import snake.utils.NodeName;

import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class FoodSpawner extends Component
{
	public var foodColor		(default, null): Int;
	public var foodScorePoint	(default, null): Int;
	public var foodCount		(default, null): Int;
	public var foodSpawnRate	(default, null): Float;
	
	private var foodSpawnerEntity: 		Entity;
	private var foodSpawnerDisposer: 	Disposer;
	private var foodMaxCount: 			Int;
	
	private static inline var MAX_FOOD_COUNT = 1;
	
	public function new() {	
		foodColor = 0xFF2020;
		foodScorePoint = 1;
		foodCount = 0;
		foodSpawnRate = 1;
		foodMaxCount = MAX_FOOD_COUNT;
	}
	
	public function Create(color: Int, scorePoint: Int, spawnRate: Float, maxCount: Int) {
		foodColor = color;
		foodScorePoint = scorePoint;
		foodSpawnRate = spawnRate;
		foodMaxCount = maxCount;
		foodCount = 0;
		
		foodSpawnerEntity = new Entity();
		foodSpawnerDisposer = new Disposer();
	}
	
	public function Run() {
		var script: Script = new Script();
		script.run(new Repeat(
			new Sequence([
				new CallFunction(function() {
					if (foodCount >= foodMaxCount)
						return;
						
					var randX: Int = Std.random(GameScreen.GRID_ROWS);
					var randY: Int = Std.random(GameScreen.GRID_COLUMNS);
					
					var node: SnakeNode = Utils.GetGridNode(randX, randY);
					
					if (node.isBlocked || node.nodeType != NodeType.None)
						return;
					
					node.SetIsBlocked(true, foodColor);
					node.SetNodeType(NodeType.Food);
					node.SetNodeNameID(GetNodeName());
					foodCount++;
				}),
				new Delay(foodSpawnRate)
			])
		));
		
		foodSpawnerEntity.add(script);
		
		foodSpawnerDisposer.add(script);
		foodSpawnerDisposer.add(foodSpawnerEntity);
	}
	
	public function SubtractFoodCount(amt: Int = 1): Void {
		foodCount -= amt;
	}
	
	public function GetNodeName(): String {
		return NodeName.NODE_FOOD_SPAWNER;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		owner.addChild(foodSpawnerEntity);
		foodSpawnerDisposer = owner.get(Disposer);
		if (foodSpawnerDisposer == null) {
			owner.add(foodSpawnerDisposer = new Disposer());
		}
	}
	
	override public function onRemoved() 
	{
		super.onRemoved();
	}
	
	override public function dispose() 
	{
		super.dispose();
		foodSpawnerDisposer.dispose();
	}
}