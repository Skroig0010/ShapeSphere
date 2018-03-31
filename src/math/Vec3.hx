package src.math;

@:forward
abstract Vec3(Vec3Data) from Vec3Data to Vec3Data{

    public inline function new(x : Float, y : Float, z : Float)this = new Vec3Data(x,y,z);

    public inline function length() return Math.sqrt(this.x*this.x + this.y*this.y + this.z*this.z);

    public inline function normalize() : Vec3{
        var l = length();
        return new Vec3(this.x/l, this.y/l, this.z/l);
    }

    @:op(-A) 
    public static inline function minus(v : Vec3) : Vec3{
        return new Vec3(-v.x, -v.y, -v.z);
    }

    @:op(A+B)
    public static inline function add(v1 : Vec3, v2 : Vec3) : Vec3{
        return new Vec3(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
    }

    @:op(A-B) 
    public static inline function sub(v1 : Vec3, v2 : Vec3) : Vec3{
        return new Vec3(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
    }

    public inline function dot(v : Vec3)return this.x * v.x + this.y * v.y + this.z * v.z;

    public inline function cross(v : Vec3)return new Vec3(
            this.y * v.z - this.z * v.y, 
            this.z * v.x - this.x * v.z,
            this.x * v.y - this.y * v.x);
}
