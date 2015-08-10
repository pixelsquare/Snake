package snake.screens;
import flambe.Disposer;
import flambe.Entity;
import snake.screens.SceneManager;

/**
 * @author Anthony Ganzon
 */
interface IScreen 
{
	public var screenName(default, null): String;
	public var screenScene(default, null): Entity;
	public var screenDisposer(default, null): Disposer;
	public function Initialize(manager: SceneManager): Entity;
}