package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Player extends FlxSprite{
    static inline var speed = 5;

    public var pID: Int;
    var _upKey: FlxKey;
    var _downKey: FlxKey;
    var _leftKey: FlxKey;
    var _rightKey: FlxKey;

    public function new(id:Int, up: FlxKey, down: FlxKey, left: FlxKey, right: FlxKey){
        super();

        pID = id;
        _upKey = up;
        _downKey = down; 
        _leftKey = left; 
        _rightKey = right; 
    }

    override public function update(e:Float):Void{
        super.update(e);

        if(FlxG.keys.anyPressed([_upKey]) && this.y > 0)    this.y -= speed;
        if(FlxG.keys.anyPressed([_downKey]) && this.y + this.height < FlxG.height)  
            this.y += speed;
        if(FlxG.keys.anyPressed([_leftKey]) && this.x > 0)  this.x -= speed;
        if(FlxG.keys.anyPressed([_rightKey]) && this.x + this.width < FlxG.width) 
            this.x += speed;
    }
}