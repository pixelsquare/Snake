package snake.pxlSq;

import haxe.xml.Fast;
import snake.SnakeNode;
import snake.screens.GameScreen;

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
	
	public static function GetSnakeGrid(x: Int, y: Int): SnakeNode {	
		var result: SnakeNode = null;
		
		for (grid in GameScreen.gameGrid) {
			if (grid.id.Equals(x, y)) {
				result = grid;
			}
		}
		
		return result;
	}
}
