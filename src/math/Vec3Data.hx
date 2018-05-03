package src.math;

class Vec3Data{
    public var x:Float;
    public var y:Float;
    public var z:Float;

    public function new(x : Float, y : Float, z : Float){
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public inline function iterator(){
        return [this.x, this.y, this.z].iterator();
    }
}
