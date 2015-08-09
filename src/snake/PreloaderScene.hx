package snake;

import flambe.System;
import flambe.asset.AssetPack;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.util.Promise;

/**
 * ...
 * @author Anthony Ganzon
 */
class PreloaderScene
{
	public static function Initialize(pack: AssetPack, promise: Promise<Dynamic>): Entity {
		var scene: Entity = new Entity();
		
		var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
		scene.addChild(new Entity().add(background));
		
		return scene;
	}
	
}