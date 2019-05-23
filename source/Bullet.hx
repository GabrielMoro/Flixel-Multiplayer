import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxVector;

class Bullet extends FlxSprite{
    var _shotVec: FlxVector;

    public function new(){
        super();
        this.loadGraphic(AssetPaths.fireball16__png, true, 16);
        this.animation.add("shot", [4,5,6,7,8], 15);

        this.scale.set(0.8,0.8);   // 
        this.updateHitbox();       // Resjuste do tamanho da hitbox
        this.scale.set(1,1);       //

        kill();
    }

    override public function update(elapsed: Float): Void{
		if(!isOnScreen()){
			kill();
		}
		super.update(elapsed);
    }
}