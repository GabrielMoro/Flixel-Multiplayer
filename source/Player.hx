package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Player extends FlxSprite{
    static inline var speed = 20;

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

        velocity.set(0, 0);
        maxVelocity.x = 50;
        maxVelocity.y = 50;

        _upKey = keys[0];
        _downKey = keys[1]; 
        _leftKey = keys[2]; 
        _rightKey = keys[3];
        _fireKey = keys[4];
    }

    override public function update(e:Float):Void{
        super.update(e);

        var send: Bool = false;
        var mp = cast(FlxG.state, MultiplayerState).MP;

        if(this.x <= 0 || this.x + this.width >= FlxG.width)
            this.velocity.x *= -1;
        if(this.y <= 0 || this.y + this.height >= FlxG.height)
            this.velocity.y *= -1;

        if(FlxG.keys.anyPressed([_upKey]) && this.y > 0)  {
            acceleration.y += -speed;
            send = true;
        }
        if(FlxG.keys.anyPressed([_downKey]) && this.y + this.height < FlxG.height){
            acceleration.y += speed;
            send = true;
        }
        if(FlxG.keys.anyPressed([_leftKey]) && this.x > 0){
            acceleration.x -= speed;
            send = true;
        }  
        if(FlxG.keys.anyPressed([_rightKey]) && this.x + this.width < FlxG.width){
            acceleration.x += speed;
            send = true;
        } 
        if(send)
            mp.sendMove(this);

        if(FlxG.keys.anyJustPressed([_fireKey])){
            cast(FlxG.state, MultiplayerState).shooting(this.x, this.y);
            mp.sendNoOverflow([
                Multiplayer.OP_MOVE,
                mp.getMyIDMultiplayer(),
                x, y
            ]);
        }
    }
}