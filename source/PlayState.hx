package;

import openfl.geom.Matrix;
import openfl.geom.Point;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{

	// Camera that renders the game for the player
	public var defaultCam:FlxCamera;

	// Intermediate camera that anything requiring an outline should use
	public var outlineCam:FlxCamera;

	// Screen-sized sprite that will have the shader applied to it
	public var outlineSprite:FlxSprite;

	// Just to help align cameras for the demo
	var width = 160;
	var height = 90;

	var sprite:FlxSprite;
	override public function create():Void
	{
		super.create();

		defaultCam = new FlxCamera(0, 0, width, height);
		defaultCam.bgColor = FlxColor.BLACK;

		outlineCam = new FlxCamera(0, height, width, height);
		outlineCam.bgColor = FlxColor.TRANSPARENT;

		// Set default camera as our main camera
		FlxG.cameras.reset(defaultCam);
		// add the outline camera second
		FlxG.cameras.add(outlineCam);

		// Simple spinning sprite
		sprite = new FlxSprite(width * 0.5 - 8, height * 0.5 - 8);
		sprite.makeGraphic(16, 16, FlxColor.GREEN);
		sprite.angularVelocity = 20;
		sprite.camera = outlineCam;
		add(sprite);

		// create outlineSprite
		outlineSprite = new FlxSprite();
		outlineSprite.useFramePixels = true;
		outlineSprite.makeGraphic(width, height, FlxColor.TRANSPARENT);
		// per my other comments on the discord, I'm wanting to do an outline that
		// applies to multiple sprites instead of individual sprites.
		// NOTE: Using this shader doesn't appear related to the anti-aliasing
		//       weirdness I'm seeing when copying the camera's buffer/canvas
		//       into the outlineSprite's pixel data
		// outlineSprite.shader = new shaders.Outline(0xFFFFFFFF, 1, 1);
		outlineSprite.camera = defaultCam;
		add(outlineSprite);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		// This line (per @dean in the discord) doesn't clear the pixels as I would expect
		// outlineSprite.graphic.bitmap.fillRect(sprite.graphic.bitmap.rect, 0x0);

		// This is another variant I tried with no luck. Old pixels still remain
		// NOTE: This line also requires us to call `outlineSprite.drawFrame()`
		//       BEFORE calling this line
		//outlineSprite.framePixels.fillRect(sprite.graphic.bitmap.rect, 0x0);

		// This line, while seemingly wrong, is the only way I can find to actually get
		// `outlineSprite` empty and ready to have the buffer/canvas copied over again
		outlineSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);

		outlineSprite.drawFrame();
		var screenPixels = outlineSprite.framePixels;

		// This pixel copy seems to be the issue, but I haven't spotted as to why
		if (FlxG.renderBlit)
			screenPixels.copyPixels(outlineCam.buffer, FlxG.camera.buffer.rect, new Point(), true);
		else
			screenPixels.draw(outlineCam.canvas, new Matrix(1, 0, 0, 1, 0, 0));
	}

	override public function draw() {
		super.draw();
		// I tried putting the above logic into the draw function here, but was only
		// getting a black screen, so I'm not sure how to use this function
		// properly
	}
}
