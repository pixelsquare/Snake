package snake;

import flambe.Entity;
import flambe.scene.Director;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.util.Promise;

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
		
		//loader.progressChanged.connect(function() {
			//Utils.ConsoleLog(loader.progress + " " + loader.total);
		//});
		
		loader.get(function(pack: AssetPack) {
			var preloader: Entity = PreloaderScene.Initialize(pack, loader);
			director.unwindToScene(preloader);
			
			var sceneManager: SceneManager = new SceneManager();
			sceneManager.Initialize(pack, director, storage);
			sceneManager.ShowTitleScreen(false);
		});
		
        //loader.get(onSuccess);
    }

    //private static function onSuccess (pack :AssetPack)
    //{
        //// Add a solid color background
        //var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        //System.root.addChild(new Entity().add(background));
		
        //// Add a plane that moves along the screen
        //var plane = new ImageSprite(pack.getTexture("plane"));
        //plane.x._ = 30;
        //plane.y.animateTo(200, 6);
        //System.root.addChild(new Entity().add(plane));
    //}
}
