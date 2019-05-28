package;

import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;

class MultiplayerState extends FlxState{
    public var players: FlxGroup;
	public var bullets: FlxGroup;

	public var MP: Multiplayer;

	override public function create():Void{		
		players = new FlxGroup();
        add(players);

		players.add(new Player(0, [FlxKey.W, FlxKey.S, FlxKey.A, FlxKey.D, FlxKey.SPACE]));

		MP = new Multiplayer();
		add(MP);

		bullets = new FlxGroup();
		for(i in 0...100){
            bullets.add(new Bullet());
        }

		super.create();
	}

	public function getPlayerByID(id: Int): Player{
		for (p in players)
			if(cast(p, Player).pID == id)
				return cast(p, Player);
		
		return null;
	}

    public function shooting(x: Float, y: Float):Void{
		var s: Bullet = cast bullets.getFirstAvailable();
		if(s != null){
            s.reset(x, y);
            s.velocity.x = 200;
            s.animation.play("shot");
            add(s);
		}
    }

	override public function update(e:Float):Void{
		super.update(e);
	}
}
