package shaders;

import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;

class Outline extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform vec2 size;
        uniform vec4 color;

        void main()
        {
            vec4 sample = flixel_texture2D(bitmap, openfl_TextureCoordv);
            if (sample.b == 0.) {
                float w = size.x / openfl_TextureSize.x;
                float h = size.y / openfl_TextureSize.y;

                if (flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x + w, openfl_TextureCoordv.y)).a != 0.
                || flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x - w, openfl_TextureCoordv.y)).a != 0.
                || flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y + h)).a != 0.
                || flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y - h)).a != 0.
				|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x + w, openfl_TextureCoordv.y + h)).a != 0.
				|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x + w, openfl_TextureCoordv.y - h)).a != 0.
				|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x - w, openfl_TextureCoordv.y + h)).a != 0.
				|| flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x - w, openfl_TextureCoordv.y - h)).a != 0.)
                    sample.rgb = color.rgb;
            }
            gl_FragColor = sample;
        }')

	public function new(color:FlxColor = 0xFFFFFFFF, width:Float = 1, height:Float = 1)
	{
		super();
		this.color.value = [color.red, color.green, color.blue, color.alpha];
		this.size.value = [width, height];
	}
}