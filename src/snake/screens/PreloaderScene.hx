package snake.screens;

import flambe.asset.AssetPack;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.System;
import flambe.util.Promise;
import flambe.math.FMath;

import snake.utils.AssetName;

/**
 * ...
 * @author Anthony Ganzon
 */
class PreloaderScene
{
	public static function Initialize(pack: AssetPack, promise: Promise<Dynamic>): Entity {
		var scene: Entity = new Entity();
		
		var background: FillSprite = new FillSprite(0x202020, System.stage.width, System.stage.height);
		scene.addChild(new Entity().add(background));
		
		var loadingFont: Font = new Font(pack, AssetName.FONT_VANADINE_32);
		var loadingText: TextSprite = new TextSprite(loadingFont, "Loading ...");
		loadingText.centerAnchor();
		loadingText.setXY(
			System.stage.width / 2,
			System.stage.height * 0.45
		);
		scene.addChild(new Entity().add(loadingText));
		
		var padding: Int = 20;
		var progressWidth: Float = System.stage.width - (padding * 2);
		var posY: Float = System.stage.height / 2;
		
		var fill: FillSprite = new FillSprite(0xFFFFFF, 0, 10);
		fill.setXY(padding, posY);
		
		promise.progressChanged.connect(function() {
			fill.width._ = promise.progress / promise.total * progressWidth;
			loadingText.text = "Loading ... " + Std.int((promise.progress / promise.total * 100)) + "%";
			loadingText.setXY(
				System.stage.width / 2 - (loadingText.getNaturalWidth() * 0.25),
				System.stage.height * 0.45
			);
		});
		scene.addChild(new Entity().add(fill));
		
		return scene;
	}
}