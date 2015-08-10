package snake;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.animation.AnimatedFloat;
import flambe.System;
import flambe.math.Point;
import snake.Snake.SnakeDirection;

import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class SnakeNode extends Component
{
	public var color: Int;
	public var id(default, null): GridID;
	public var x(default, null): AnimatedFloat;
	public var y(default, null): AnimatedFloat;
	public var width(default, null): AnimatedFloat;
	public var height(default, null): AnimatedFloat;
	public var isBlocked(default, null): Bool;
	
	public var oldDirection(default, null): GridID;
	public var newDirection(default, null): GridID;
	
	private var gridEntity: Entity;
	private var background: FillSprite;
	
	private static inline var COLOR_WALKABLE: Int = 0xFFFFFF;
	private static inline var COLOR_BLOCKED: Int = 0x999999;
	
	public function new() { 
		id = new GridID(0, 0);
		x = new AnimatedFloat(0);
		y = new AnimatedFloat(0);
		width = new AnimatedFloat(0);
		height = new AnimatedFloat(0);
		isBlocked = false;
		oldDirection = new GridID(0, 0);
		newDirection = new GridID(0, 0);
	}
	
	public function Initialize(): Void {
		gridEntity = new Entity();
		
		background = new FillSprite(0xFFFFFF, 0, 0);
		SetColor(0xFFFFFF);
		SetXY(0, 0);
		//SetSize(System.stage.width * 0.018, System.stage.height * 0.022);
		SetSize((System.stage.width * 0.02) * 0.8, System.stage.height * 0.02);
		gridEntity.addChild(new Entity().add(background));
	}
	
	public function SetIsBlocked(blocked: Bool, color: Int = COLOR_BLOCKED) : Void {
		isBlocked = blocked;
		
		SetColor(isBlocked ? color : COLOR_WALKABLE);
	}
	
	public function SetID(x: Int, y: Int): Void {
		this.id.SetXY(x, y);
	}
	
	public function SetColor(color: Int): Void {
		this.color = color;
		SetDirty();
	}
	
	public function SetXY(x: Float, y: Float): Void {
		this.x._ = x;
		this.y._ = y;
		SetDirty();
	}
	
	public function SetSize(width: Float, height: Float): Void {
		this.width._ = width;
		this.height._ = height;
		SetDirty();
	}
	
	public function SetDirty(): Void {
		background.setXY(x._, y._);
		background.setSize(width._, height._);
		background.color = color;
	}
	
	public function SetOldDirection(direction: GridID): Void {
		oldDirection = direction;
	}
	
	public function SetNewDirection(direction: GridID): Void {
		SetOldDirection(newDirection);
		newDirection = direction;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		owner.addChild(gridEntity);
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		x.update(dt);
		y.update(dt);
		width.update(dt);
		height.update(dt);
	}
	
	override public function dispose() 
	{
		super.dispose();
		gridEntity.dispose();
	}
	
}