package snake;
import flambe.Disposer;
import flambe.Entity;
import snake.SceneManager;

/**
 * @author Anthony Ganzon
 */
interface IScreen 
{
	public var screenDisposer(default, null): Disposer;
	public function Initialize(manager: SceneManager): Entity;
}