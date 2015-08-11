package snake;

/**
 * ...
 * @author Anthony Ganzon
 */
class GridAddress
{
	public var x(default, default): Int;
	public var y(default, default): Int;
	
	public function new(x: Int, y: Int) 
	{
		this.x = x;
		this.y = y;
	}
	
	public function SetXY(x: Int, y: Int): Void {
		this.x = x;
		this.y = y;
	}
	
	public function Equals(x: Int, y: Int): Bool {
		return this.x == x && this.y == y;
	}
	
	public function ToString(): String {
		return "ID(" + this.x + "," + this.y + ")";
	}
}