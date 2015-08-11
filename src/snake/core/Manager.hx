package snake.core;

import flambe.asset.AssetPack;
import flambe.scene.Director;
import flambe.subsystem.StorageSystem;

import snake.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class Manager
{
	public var gameAssets	(default, null): AssetPack;
	public var gameDirector	(default, null): Director;
	public var gameStorage	(default, null): StorageSystem;
	
	public function new() {	
		gameAssets = null;
		gameDirector = null;
		gameStorage = null;
	}
	
	public function Initialize(): Void { }
	
	public function SetGameAssets(assets: AssetPack): Void {
		gameAssets = assets;
	}
	
	public function SetGameDirector(director: Director): Void {
		gameDirector = director;
	}
	
	public function SetGameStorage(storage: StorageSystem): Void {
		gameStorage = storage;
	}
}