package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Player extends FlxSprite{
    static inline var speed = 5;

    public var pID: Int;
    public var simulated: Bool;
    public var lastTimeActive: Float;

    var _upKey: FlxKey;
    var _downKey: FlxKey;
    var _leftKey: FlxKey;
    var _rightKey: FlxKey;
    var _fireKey: FlxKey;

    public function new(id:Int, keys:Array<FlxKey> = null){
        super();
        pID = id;

        if(keys == null){
            simulated = true;
            // lastTimeActive = Date.now();
            return;
        }

        _upKey = keys[0];
        _downKey = keys[1]; 
        _leftKey = keys[2]; 
        _rightKey = keys[3];
        _fireKey = keys[4];
    }

    override public function update(e:Float):Void{
        super.update(e);

        if(this.x <= 0 || this.x + this.width >= FlxG.width)
            this.velocity.x *= -1;
        if(this.y <= 0 || this.y + this.height >= FlxG.height)
            this.velocity.y *= -1;

        if(FlxG.keys.anyPressed([_upKey]) && this.y > 0)    this.y -= speed;
        if(FlxG.keys.anyPressed([_downKey]) && this.y + this.height < FlxG.height)  
            this.y += speed;
        if(FlxG.keys.anyPressed([_leftKey]) && this.x > 0)  this.x -= speed;
        if(FlxG.keys.anyPressed([_rightKey]) && this.x + this.width < FlxG.width) 
            this.x += speed;
        if(FlxG.keys.anyJustPressed([_fireKey]))
            cast(FlxG.state, MultiplayerState).shooting(this.x, this.y);
    }
}