package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Multiplayer extends FlxSprite{
    // Ind 0 = OP
    public static inline var OP_NEW_PLAYER = 'n';
    public static inline var OP_PLAYER_MOVE = 'm';  // [op, player id, player x, player y, p velocity x, p velocity y]

    var _cont: Float = 0;
    var _playerID: Int;

    public function new(){
        super();

        _playerID = -1;
    }

    public function send(msg: Array<Any>):Void{
        onMessage(msg);
    }

    public function onMessage(msg: Array<Any>):Void{
        if(msg == null || msg.length == 0){
            FlxG.log.error("ERROR: EMPTY MESSAGE");
            return;
        }
        var op: String = msg[0];

        switch(op){
            case OP_PLAYER_MOVE:
                if(msg.length != 6){
                    FlxG.log.error("ERROR: MESSAGE LENGTH");                    
                }

                move(cast(msg[1], Int),     // Sender ID
                     cast(msg[2], Int),     // Sender X
                     cast(msg[3], Int),     // Sender Y
                     cast(msg[4], Float),   // Sender Velocity X
                     cast(msg[5], Float));  // Sender Velocity Y
            default: 
                FlxG.log.error("ERROR: INVALID OP " + op + "\n");
        }
    }

    public function move(inID: Int, inX: Float, inY: Float, inVelX: Float, inVelY: Float):Void{
        if(inID == _playerID)
            return;

        var p = cast(FlxG.state, MultiplayerState).getPlayerByID(inID);

        if(p != null){
            p.x = inX;
            p.y = inY;
            p.velocity.x = inVelX;
            p.velocity.y = inVelY;
        }
    }

    override public function update(e:Float):Void{
        super.update(e);

        _cont += e;

        if(_cont >= 3){
            _cont = 0;
            send([OP_PLAYER_MOVE, 1, 100, 150, 100, 100]);
        }
    }
}