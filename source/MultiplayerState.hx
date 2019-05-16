package;

import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;

class MultiplayerState extends FlxState{
    var _players: FlxGroup;
	var _MP: Multiplayer;

	override public function create():Void{		
		_players = new FlxGroup();
        add(_players);

		_players.add(new Player(0, FlxKey.UP, FlxKey.DOWN, FlxKey.LEFT, FlxKey.RIGHT));
		_players.add(new Player(1, FlxKey.W, FlxKey.S, FlxKey.A, FlxKey.D));

		_MP = new Multiplayer();
		add(_MP);

		super.create();
	}

	public function getPlayerByID(id: Int): Player{
		for (p in _players)
			if(cast(p, Player).pID == id)
				return cast(p, Player);
		
		return null;
	}

	override public function update(e:Float):Void{
		super.update(e);
	}
}
