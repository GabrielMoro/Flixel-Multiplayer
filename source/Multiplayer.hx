package;

import networking.Network;
import networking.utils.NetworkEvent;
import networking.utils.NetworkMode;
import networking.sessions.Session;

import openfl.Lib;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

// id 8

class Multiplayer extends FlxSprite{
    public static inline var SERVER_IP = '172.20.83.155';

    public static inline var overflowPeriod = 1;
    public static inline var contPeriod = 3;

    // Ind 0 = OP
    public static inline var OP_NEW_PLAYER = 'n';
    public static inline var OP_MOVE = 'm';         // [op, player id, player x, player y, p velocity x, p velocity y]
    public static inline var OP_SHOOT = 't';        // [op, player id, player x, player y]
    public static inline var OP_DIED = 'o';         // [op, player id, player x, player y]

    var _cont: Float = 0;
    var _overflowCont: Float = 0;
    var _overflowLastOP: String = "";
    var _playerID: String;

    var _client: Session;

    public function new(){
        super();
        createClient();

        _playerID = '8';
    }

    function createClient(){
        _client = Network.registerSession(NetworkMode.CLIENT, 
        { ip: SERVER_IP, port: 8888, flash_policy_file_url: 'http://' + SERVER_IP + ':9999/crossdomain.xml' });

        _client.addEventListener(NetworkEvent.MESSAGE_RECEIVED, onMessageReceived);

        _client.addEventListener(NetworkEvent.INIT_SUCCESS, onInitSuccess);

        _client.start();
    }

    function onInitSuccess(event: NetworkEvent):Void{
        FlxG.log.add("A: " + event.data);
    }

    public function getMyIDMultiplayer():String{
        return _playerID;
    }

    public function send(msg: Array<Any>):Void{
        // var session = Network.sessions[0];
        _client.send(msg);
    }

    public function sendNoOverflow(msg: Array<Any>):Void{
        var op = msg[0];

        if(op == _overflowLastOP)
            return;

        _overflowLastOP = op;
        send(msg);
    }

    public function sendMove(p: Player):Void{
        sendNoOverflow([
            OP_MOVE,
            _playerID,
            p.x, p.y,
            p.velocity.x,
            p.velocity.y,
            p.acceleration.x,
            p.acceleration.y
        ]);
    }

    function verifySender(inID: String): Bool{
        if(inID == _playerID)
            return false;

        var p = getPlayer(inID);

        if(p == null){
            cast(FlxG.state, MultiplayerState).players.add(new Player(inID));
        }

        return true;
    }

    public function move(inID: String, inX: Float, inY: Float, inVelX: Float, inVelY: Float, inAccelX: Float, inAccelY: Float):Void{
        if(!verifySender(inID))
            return;

        var p = getPlayer(inID);

        if(p == null)
            return;

        p.x = inX;
        p.y = inY;
        p.velocity.x = inVelX;
        p.velocity.y = inVelY;
        p.acceleration.x = inAccelX;
        p.acceleration.y = inAccelY;
        
    }

    public function shoot(inID: String, inX: Float, inY: Float):Void{
        if(!verifySender(inID))
            return;

        var state: MultiplayerState = getState();
        var p = getPlayer(inID);

        if(p == null)    
            return;

        p.x = inX;
        p.y = inY;
        state.shooting(inX, inY);
    }

    public function died(inID: String, inX: Float, inY: Float):Void{
        var p = getPlayer(inID);

        if(p == null)    
            return;

        p.kill();
    }

    public function getState():MultiplayerState{
        return cast(FlxG.state, MultiplayerState);
    }

    public function getPlayer(inID: String):Player{
        return getState().getPlayerByID(inID);
    }

    public function onMessage(msg: Array<Any>):Void{
        if(msg == null || msg.length == 0){
            FlxG.log.error("ERROR: EMPTY MESSAGE");
            return;
        }
        var op: String = msg[0];

        var senderID: String = cast(msg[1], String);
        if(!verifySender(senderID))
            return;
        
        switch(op){
            case OP_MOVE:
                if(msg.length != 6){
                    FlxG.log.error("ERROR: MESSAGE LENGTH");                    
                }

                move(cast(msg[1], String),  // Sender ID
                     cast(msg[2], Float),   // Sender X
                     cast(msg[3], Float),   // Sender Y
                     cast(msg[4], Float),   // Sender Velocity X
                     cast(msg[5], Float),   // Sender Velocity Y
                     cast(msg[6], Float),   // Sender Acceleration Y
                     cast(msg[7], Float));  // Sender Acceleration Y
            case OP_SHOOT:
                if(msg.length != 4){
                    FlxG.log.error("ERROR: MESSAGE LENGTH");                    
                }

                shoot(cast(msg[1], String),  // Sender ID
                      cast(msg[2], Float),   // Sender X
                      cast(msg[3], Float));  // Sender Y);
            case OP_DIED:
                if(msg.length != 4){
                    FlxG.log.error("ERROR: MESSAGE LENGTH");
                }

                died(cast(msg[1], String),   // Sender ID
                      cast(msg[2], Float),   // Sender X
                      cast(msg[3], Float));  // Sender Y);
            default: 
                FlxG.log.error("ERROR: INVALID OP " + op + "\n");
        }
    }

    function onMessageReceived(event: NetworkEvent):Void{
        onMessage(event.data);      
    }

    override public function update(e:Float):Void{
        super.update(e);

        _cont += e;
        _overflowCont += e;

        if(_overflowCont >= overflowPeriod){
            _overflowCont = 0;
            _overflowLastOP = "";
        }

        if(_cont >= contPeriod){
            _cont = 0;
        }
    }
}