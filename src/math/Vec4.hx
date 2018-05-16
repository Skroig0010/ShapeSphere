package src.math;

@:forward
abstract Vec4(Vec4Data) from Vec4Data to Vec4Data{

    public inline function new(x : Float, y : Float, z : Float, w : Float)this = new Vec4Data(x,y,z,w);

    public inline function length() return Math.sqrt(this.x*this.x + this.y*this.y + this.z*this.z + this.w*this.w);

    public inline function normalize() : Vec4{
        var l = length();
        return new Vec4(this.x/l, this.y/l, this.z/l, this.w/l);
    }

    @:op(-A) 
    public static inline function minus(v : Vec4) : Vec4{
        return new Vec4(-v.x, -v.y, -v.z, -v.w);
    }

    @:op(A+B)
    public static inline function add(v1 : Vec4, v2 : Vec4) : Vec4{
        return new Vec4(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z, v1.w + v2.w);
    }

    @:op(A-B) 
    public static inline function sub(v1 : Vec4, v2 : Vec4) : Vec4{
        return new Vec4(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z, v1.w - v2.w);
    }

    @:op(A==B)
    public static inline function equals(v1 : Vec4, v2 : Vec4) : Bool{
        return v1.x == v2.x && v1.y == v2.y && v1.z == v2.z && v1.w == v2.w;
    }

    // public inline function dot(v : Vec4)return this.x * v.x + this.y * v.y + this.z * v.z;

    /*
    public inline function cross(v : Vec4)return new Vec4(
            this.y * v.z - this.z * v.y, 
            this.z * v.x - this.x * v.z,
            this.x * v.y - this.y * v.x);
     */
}
