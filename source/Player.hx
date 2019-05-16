package;

import flixel.FlxSprite;
import flixel.FlxG;

class Player extends FlxSprite{
    public function new(){
        super();
    }

    override public function update(e:Float):Void{
        super.update(e);

        if(FlxG.keys.pressed.UP)
            this.y -= 5;
        if(FlxG.keys.pressed.DOWN)
            this.y += 5;
        if(FlxG.keys.pressed.LEFT)
            this.x -= 5;
        if(FlxG.keys.pressed.RIGHT)
            this.x += 5;
    }
}