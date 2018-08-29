package shapesphere.math;

@:forward
abstract Quaternion(QuaternionData) from QuaternionData to QuaternionData{

    public inline function new(w : Float, x : Float, y : Float, z : Float)this = new QuaternionData(x,y,z,w);

    public static var identity(get, never) : Quaternion;
    static inline function get_identity()return new Quaternion(1, 0, 0, 0);

    public inline function lengthSquared() return this.x*this.x + this.y*this.y + this.z*this.z + this.w*this.w;

    public inline function length() return Math.sqrt(this.x*this.x + this.y*this.y + this.z*this.z + this.w*this.w);

    public inline function normalize() : Quaternion{
        var l = length();
        return new Quaternion(this.x/l, this.y/l, this.z/l, this.w/l);
    }

    @:op(-A) 
    public static inline function minus(v : Quaternion) : Quaternion{
        return new Quaternion(-v.x, -v.y, -v.z, -v.w);
    }

    public static inline function inverse(v : Quaternion) : Quaternion{
        var len = v.lengthSquared();
        return new Quaternion(-v.x / len, -v.y / len, -v.z / len, v.w * len);
    }

    @:op(A+B)
    public static inline function add(v1 : Quaternion, v2 : Quaternion) : Quaternion{
        return new Quaternion(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z, v1.w + v2.w);
    }

    @:op(A-B) 
    public static inline function sub(v1 : Quaternion, v2 : Quaternion) : Quaternion{
        return new Quaternion(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z, v1.w - v2.w);
    }

    @:op(A*B)
    public static inline function multScalar(f : Float, v : Quaternion) : Quaternion{
        return new Quaternion(v.x * f, v.y * f, v.z * f, v.w * f);
    }

    @:op(A*B)
    public static inline function mult(v1 : Quaternion, v2 : Quaternion) : Quaternion{
        var w = v1.w * v2.w - (v1.x * v2.x + v1.y * v2.y + v1.z * v2.z);
        var xy = v1.x * v2.y - v1.y * v2.x;
        var yz = v1.y * v2.z - v1.z * v2.y;
        var zx = v1.z * v2.x - v1.x * v2.z;
        var x = v1.x * v2.w + v2.x * v1.w + yz;
        var y = v1.y * v2.w + v2.y * v1.w + zx;
        var z = v1.z * v2.w + v2.z * v1.w + xy;
        return new Quaternion(x, y, z, w);
    }

    @:op(A/B)
    public static inline function divideScalar(v : Quaternion, f : Float) : Quaternion{
        return new Quaternion(v.x / f, v.y / f, v.z / f, v.w / f);
    }

    @:op(A/B)
    public static inline function divide(v1 : Quaternion, v2 : Quaternion) : Quaternion{
        return v1 * inverse(v2);
    }

    @:op(A==B)
    public static inline function equals(v1 : Quaternion, v2 : Quaternion) : Bool{
        return v1.x == v2.x && v1.y == v2.y && v1.z == v2.z && v1.w == v2.w;
    }

    public inline function dot(v : Quaternion)return this.x * v.x + this.y * v.y + this.z * v.z;

    /*
    public inline function cross(v : Quaternion)return new Quaternion(
            this.y * v.z - this.z * v.y, 
            this.z * v.x - this.x * v.z,
            this.x * v.y - this.y * v.x);
     */
}
