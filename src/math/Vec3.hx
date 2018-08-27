package src.math;

@:forward
abstract Vec3(Vec3Data) from Vec3Data to Vec3Data{

    public inline function new(x : Float, y : Float, z : Float)this = new Vec3Data(x,y,z);

    public static inline function fromVec2(v : Vec2, z)return new Vec3Data(v.x, v.y, z);

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

    @:op(A==B)
    public static inline function equals(v1 : Vec3, v2 : Vec3) : Bool{
        return v1.x == v2.x && v1.y == v2.y && v1.z == v2.z;
    }

    @:op(A!=B)
    public static inline function neqals(v1 : Vec3, v2 : Vec3) : Bool{
        return !equals(v1, v2);
    }

    public inline function dot(v : Vec3)return this.x * v.x + this.y * v.y + this.z * v.z;

    public inline function cross(v : Vec3)return new Vec3(
            this.y * v.z - this.z * v.y, 
            this.z * v.x - this.x * v.z,
            this.x * v.y - this.y * v.x);

    public var xy(get, never) : Vec2;
    public var xz(get, never) : Vec2;
    public var yz(get, never) : Vec2;
    public var yx(get, never) : Vec2;
    public var zx(get, never) : Vec2;
    public var zy(get, never) : Vec2;

    private inline function get_xy()return new Vec2(this.x, this.y);
    private inline function get_xz()return new Vec2(this.x, this.z);
    private inline function get_yz()return new Vec2(this.y, this.z);
    private inline function get_yx()return new Vec2(this.y, this.x);
    private inline function get_zx()return new Vec2(this.z, this.x);
    private inline function get_zy()return new Vec2(this.z, this.y);

}
