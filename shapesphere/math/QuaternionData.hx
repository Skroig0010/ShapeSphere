package shapesphere.math;

class QuaternionData{
    public var w : Float;
    public var x : Float;
    public var y : Float;
    public var z : Float;

    public function new(w : Float, x : Float, y : Float, z : Float){
        this.w = w;
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public inline function iterator(){
        return [this.w, this.x, this.y, this.z].iterator();
    }
}
