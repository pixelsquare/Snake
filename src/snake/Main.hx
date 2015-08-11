package snake;

import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.Entity;
import flambe.scene.Director;
import flambe.System;
import snake.core.GameManager;
import snake.core.SceneManager;
import snake.screens.PreloaderScene;

import snake.pxlSq.Utils;

class Main
{
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();
		
		var director = new Director();
		System.root.add(director);
		
		var storage = System.storage;

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
		
		loader.get(function(pack: AssetPack) {
			var promise = System.loadAssetPack(Manifest.fromAssets("main"));
			promise.get(function(mainPack: AssetPack) {
				var gameManager: GameManager = new GameManager();
				gameManager.SetGameAssets(mainPack);
				gameManager.SetGameDirector(director);
				gameManager.SetGameStorage(storage);
				gameManager.Initialize();
				
				var sceneManager: SceneManager = gameManager;
				sceneManager.ShowTitleScreen(true);
			});
			
			var preloader: Entity = PreloaderScene.Initialize(pack, promise);
			director.unwindToScene(preloader);
		});
    }
}
