package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Multiplayer extends FlxSprite{
    var _cont: Float = 0;

    public function new(){
        super();
    }

    override public function update(e:Float):Void{
        super.update(e);

        _cont += e;

        if(_cont >= 1){
            _cont = 0;
            var p = cast(FlxG.state, MultiplayerState).getPlayerByID(1);

            if(p != null)
                p.x += 5;
        }
    }
}