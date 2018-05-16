package src.math;

class Vec4Data{
    public var x : Float;
    public var y : Float;
    public var z : Float;
    public var w : Float;

    public function new(x : Float, y : Float, z : Float, w : Float){
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }

    public inline function iterator(){
        return [this.x, this.y, this.z, this.w].iterator();
    }
}
