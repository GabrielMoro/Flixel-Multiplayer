package;

import flixel.FlxState;
import flixel.group.FlxGroup;

class MultiplayerState extends FlxState{
    var _players: FlxGroup;

	override public function create():Void{
        _players = new FlxGroup();
        add(_players);

		_players.add(new Player());

		super.create();
	}

	override public function update(e:Float):Void{
		super.update(e);
	}
}
