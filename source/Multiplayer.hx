package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Multiplayer extends FlxSprite{
    // Ind 0 = OP
    public static inline var OP_NEW_PLAYER = 'n';
    public static inline var OP_MOVE = 'm';  // [op, player id, player x, player y, p velocity x, p velocity y]
    public static inline var OP_SHOOT = 's';        // [op, player id, player x, player y]

    var _cont: Float = 0;
    var _playerID: Int;

    public function new(){
        super();

        _playerID = -1;
    }

    public function send(msg: Array<Any>):Void{
        onMessage(msg);
    }

    function verifySender(inID: Int): Bool{
        if(inID == _playerID)
            return false;

        var p = cast(FlxG.state, MultiplayerState).getPlayerByID(inID);

        if(p == null){
            cast(FlxG.state, MultiplayerState).players.add(new Player(inID));
        }

        return true;
    }

    public function move(inID: Int, inX: Float, inY: Float, inVelX: Float, inVelY: Float):Void{
        if(!verifySender(inID))
            return;

        var p = cast(FlxG.state, MultiplayerState).getPlayerByID(inID);

        if(p == null)
            return;

        p.x = inX;
        p.y = inY;
        p.velocity.x = inVelX;
        p.velocity.y = inVelY;
        
    }

    public function shoot(inID: Int, inX: Float, inY: Float){
        if(!verifySender(inID))
            return;

        var state: MultiplayerState = 
            cast(FlxG.state, MultiplayerState);
        var p = cast(FlxG.state, MultiplayerState).getPlayerByID(inID);

        if(p == null)    
            null;

        p.x = inX;
        p.y = inY;
        state.shooting(inX, inY);
    }

    public function onMessage(msg: Array<Any>):Void{
        if(msg == null || msg.length == 0){
            FlxG.log.error("ERROR: EMPTY MESSAGE");
            return;
        }
        var op: String = msg[0];

        var senderID: Int = cast(msg[1], Int);
        if(!verifySender(senderID))
            return;
        
        switch(op){
            case OP_MOVE:
                if(msg.length != 6){
                    FlxG.log.error("ERROR: MESSAGE LENGTH");                    
                }

                move(cast(msg[1], Int),     // Sender ID
                     cast(msg[2], Float),   // Sender X
                     cast(msg[3], Float),   // Sender Y
                     cast(msg[4], Float),   // Sender Velocity X
                     cast(msg[5], Float));  // Sender Velocity Y
            case OP_SHOOT:
                if(msg.length != 4){
                    FlxG.log.error("ERROR: MESSAGE LENGTH");                    
                }

                shoot(cast(msg[1], Int),     // Sender ID
                      cast(msg[2], Float),   // Sender X
                      cast(msg[3], Float));  // Sender Y);
            default: 
                FlxG.log.error("ERROR: INVALID OP " + op + "\n");
        }
    }

    override public function update(e:Float):Void{
        super.update(e);

        _cont += e;

        if(_cont >= 3){
            _cont = 0;
            send([OP_MOVE, 1, 
            FlxG.random.int(0, Std.int(FlxG.width / 2)), FlxG.random.int(0, Std.int(FlxG.height / 2)), 
            FlxG.random.float(-100, 100), FlxG.random.float(-100, 100)]);
            
            send([OP_MOVE, 2, 
            FlxG.random.int(0, Std.int(FlxG.width / 2)), FlxG.random.int(0, Std.int(FlxG.height / 2)), 
            FlxG.random.float(-100, 100), FlxG.random.float(-100, 100)]);
            
            send([OP_MOVE, 3, 
            FlxG.random.int(0, Std.int(FlxG.width / 2)), FlxG.random.int(0, Std.int(FlxG.height / 2)), 
            FlxG.random.float(-200, -100), FlxG.random.float(-200, -100)]);

            send([OP_SHOOT, 3, 
            FlxG.random.int(0, Std.int(FlxG.width / 2)), FlxG.random.int(0, Std.int(FlxG.height / 2))]);
        }
    }
}