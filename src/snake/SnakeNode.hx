package snake;

import flambe.animation.AnimatedFloat;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.System;

import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */

enum NodeType {
	None;
	Wall;
	Snake;
	Food;
}

class SnakeNode extends Component
{
	public var x			(default, null): AnimatedFloat;
	public var y			(default, null): AnimatedFloat;
	public var width		(default, null): AnimatedFloat;
	public var height		(default, null): AnimatedFloat;
	public var color		(default, null): Int;
	public var gridAddress	(default, null): GridAddress;
	
	public var nodeNameId	(default, null): String;
	public var nodeType		(default, null): NodeType;
	public var isBlocked	(default, null): Bool;
	
	// Stores the previous direction of the node
	public var oldDirection	(default, null): GridAddress;
	public var newDirection	(default, null): GridAddress;
	
	private var nodeEntity: Entity;
	private var texture: 	FillSprite;
	
	private var nodeDisposer: Disposer;
	
	private static inline var COLOR_DEFAULT: 	Int = 0xFFFFFF;
	private static inline var COLOR_WALKABLE: 	Int = 0x202020;
	private static inline var COLOR_BLOCKED: 	Int = 0x999999;
	
	public function new() { 
		x = new AnimatedFloat(0);
		y = new AnimatedFloat(0);
		width = new AnimatedFloat(0);
		height = new AnimatedFloat(0);
		color = 0;
		gridAddress = new GridAddress(0, 0);
		
		nodeNameId = "";
		nodeType = NodeType.None;
		isBlocked = false;
		
		oldDirection = new GridAddress(0, 0);
		newDirection = new GridAddress(0, 0);
		
		nodeDisposer = new Disposer();
	}
	
	public function Initialize(): Void {
		nodeEntity = new Entity();
		nodeDisposer.add(nodeEntity);
		
		x._ = 0;
		y._ = 0;
		width._ = (System.stage.width * 0.025) * 0.75;
		height._ = System.stage.height * 0.025;
		color = COLOR_DEFAULT;
		
		texture = new FillSprite(color, width._, height._);
		nodeEntity.addChild(new Entity().add(texture));
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
	
	public function SetColor(color: Int = COLOR_DEFAULT): Void {
		this.color = color;
		SetDirty();
	}
	
	public function SetGridAddress(x: Int, y: Int): Void {
		gridAddress.SetXY(x, y);
	}
	
	public function SetNodeNameID(nameId: String): Void {
		this.nodeNameId = nameId;
	}
	
	public function SetNodeType(type: NodeType): Void {
		nodeType = type;
	}
	
	public function SetIsBlocked(blocked: Bool, color: Int = COLOR_BLOCKED) : Void {
		isBlocked = blocked;
		
		SetColor(isBlocked ? color : COLOR_WALKABLE);
	}
		
	public function SetDirty(): Void {
		texture.setXY(x._, y._);
		texture.setSize(width._, height._);
		texture.color = color;
	}
	
	public function SetOldDirection(direction: GridAddress): Void {
		if (nodeType != NodeType.Snake)
			return;
		
		oldDirection = direction;
	}
	
	public function SetNewDirection(direction: GridAddress): Void {
		if (nodeType != NodeType.Snake)
			return;
			
		oldDirection = newDirection;
		newDirection = direction;
	}
	
	public function ResetNode(): Void {
		x._ = 0;
		y._ = 0;
		width._ = (System.stage.width * 0.025) * 0.75;
		height._ = System.stage.height * 0.025;
		color = COLOR_DEFAULT;
		gridAddress = new GridAddress(0, 0);
		
		nodeNameId = "";
		nodeType = NodeType.None;
		isBlocked = false;
		
		oldDirection = new GridAddress(0, 0);
		newDirection = new GridAddress(0, 0);
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		owner.addChild(nodeEntity);
		
		nodeDisposer = owner.get(Disposer);
		if (nodeDisposer == null) {
			owner.add(nodeDisposer = new Disposer());
		}
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
		nodeDisposer.dispose();
	}
}