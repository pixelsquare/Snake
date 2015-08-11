package snake.pxlSq;

import haxe.xml.Fast;
import snake.GridAddress;
import snake.screens.GameScreen;
import snake.SnakeGame.SnakeDirection;
import snake.SnakeNode;

#if flash
import flash.external.ExternalInterface;
#end

/**
 * ...
 * @author Anthony Ganzon
 * Console logger for debugging purposes.
 * NOTE: Works only with flash build
 */
class Utils
{
	/* Remove this on mobile builds */
	public static function ConsoleLog(str: String) {
		#if flash
		ExternalInterface.call("console.log", str);
		#end
	}
	
	public static function GetNodeFrom(xmlNode: Fast, nodeName: String): Fast {
		for (n in xmlNode.nodes.node) {
			if (n.has.name && n.att.name == nodeName) {
				return n;
			}
		}
		
		return null;
	}
	
	public static function GetGridNode(x: Int, y: Int): SnakeNode {	
		var result: SnakeNode = null;
		
		for (grid in GameScreen.gameGrid) {
			if (grid.gridAddress.Equals(x, y)) {
				result = grid;
			}
		}
		
		return result;
	}
	
	public static function GetGridDirection(direction: SnakeDirection): GridAddress {
		var result: GridAddress = new GridAddress(0, 0);
		
		if (direction == SnakeDirection.Right) {
			result.SetXY(1, 0);
		}
		else if (direction == SnakeDirection.Left) {
			result.SetXY(-1, 0);
		}
		else if (direction == SnakeDirection.Up) {
			result.SetXY(0,  1);
		}
		else if (direction == SnakeDirection.Down) {
			result.SetXY(0, -1);
		}
		
		return result;
	}
	
	public static function GetSnakeDirection(x: Int, y: Int): SnakeDirection {
		var result: SnakeDirection = SnakeDirection.None;
		
		if (x == 1 && y == 0) {
			result = SnakeDirection.Right;
		}
		else if (x == -1 && y == 0) {
			result = SnakeDirection.Left;
		}
		else if (x == 0 && y == 1) {
			result = SnakeDirection.Up;
		}
		else if (x == 0 && y == -1) {
			result = SnakeDirection.Down;
		}
		
		return result;
	}
}
