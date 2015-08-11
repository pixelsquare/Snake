package snake.screens;

import flambe.display.FillSprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.scene.Scene;

/**
 * @author Anthony Ganzon
 */
interface IScreen 
{
	public var screenBackground		(default, null): FillSprite;
	public var screenScene			(default, null): Scene;
	public var screenEntity			(default, null): Entity;
	public var screenDisposer		(default, null): Disposer;
	
	public function ScreenEntity(): 				Entity;
	public function SetBackgroundColor(color: Int): Void;
	public function GetScreenName(): 				String;
}