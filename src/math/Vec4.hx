package src.math;

@:forward
abstract Vec4(Vec4Data) from Vec4Data to Vec4Data{

    public inline function new(x : Float, y : Float, z : Float, w : Float)this = new Vec4Data(x,y,z,w);

    public static inline function fromVec3(v : Vec3, w : Float)return new Vec4Data(v.x, v.y, v.z, w);
    public static inline function fromVec2(v : Vec2, z : Float, w : Float)return new Vec4Data(v.x, v.y, z, w);

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

    public var xy(get, never) : Vec2;
    public var xz(get, never) : Vec2;
    public var yz(get, never) : Vec2;
    public var yx(get, never) : Vec2;
    public var zx(get, never) : Vec2;
    public var zy(get, never) : Vec2;

    public var xyz(get, never) : Vec3;
    public var xyw(get, never) : Vec3;
    public var xzw(get, never) : Vec3;
    public var xzy(get, never) : Vec3;
    public var xwy(get, never) : Vec3;
    public var xwz(get, never) : Vec3;

    public var yxz(get, never) : Vec3;
    public var yxw(get, never) : Vec3;
    public var yzw(get, never) : Vec3;
    public var yzx(get, never) : Vec3;
    public var ywx(get, never) : Vec3;
    public var ywz(get, never) : Vec3;

    public var zxy(get, never) : Vec3;
    public var zxw(get, never) : Vec3;
    public var zyw(get, never) : Vec3;
    public var zyx(get, never) : Vec3;
    public var zwx(get, never) : Vec3;
    public var zwy(get, never) : Vec3;

    public var wxy(get, never) : Vec3;
    public var wxz(get, never) : Vec3;
    public var wyz(get, never) : Vec3;
    public var wyx(get, never) : Vec3;
    public var wzx(get, never) : Vec3;
    public var wzy(get, never) : Vec3;


    private inline function get_xy()return new Vec2(this.x, this.y);
    private inline function get_xz()return new Vec2(this.x, this.z);
    private inline function get_yz()return new Vec2(this.y, this.z);
    private inline function get_yx()return new Vec2(this.y, this.x);
    private inline function get_zx()return new Vec2(this.z, this.x);
    private inline function get_zy()return new Vec2(this.z, this.y);

    private inline function get_xyz()return new Vec3(this.x, this.y, this.z);
    private inline function get_xyw()return new Vec3(this.x, this.y, this.w);
    private inline function get_xzw()return new Vec3(this.x, this.z, this.w);
    private inline function get_xzy()return new Vec3(this.x, this.z, this.y);
    private inline function get_xwy()return new Vec3(this.x, this.w, this.y);
    private inline function get_xwz()return new Vec3(this.x, this.w, this.z);

    private inline function get_yxz()return new Vec3(this.y, this.x, this.z);
    private inline function get_yxw()return new Vec3(this.y, this.x, this.w);
    private inline function get_yzw()return new Vec3(this.y, this.z, this.w);
    private inline function get_yzx()return new Vec3(this.y, this.z, this.x);
    private inline function get_ywx()return new Vec3(this.y, this.w, this.x);
    private inline function get_ywz()return new Vec3(this.y, this.w, this.z);

    private inline function get_zxy()return new Vec3(this.z, this.x, this.y);
    private inline function get_zxw()return new Vec3(this.z, this.x, this.w);
    private inline function get_zyw()return new Vec3(this.z, this.y, this.w);
    private inline function get_zyx()return new Vec3(this.z, this.y, this.x);
    private inline function get_zwx()return new Vec3(this.z, this.w, this.x);
    private inline function get_zwy()return new Vec3(this.z, this.w, this.y);

    private inline function get_wxy()return new Vec3(this.w, this.x, this.y);
    private inline function get_wxz()return new Vec3(this.w, this.x, this.z);
    private inline function get_wyz()return new Vec3(this.w, this.y, this.z);
    private inline function get_wyx()return new Vec3(this.w, this.y, this.x);
    private inline function get_wzx()return new Vec3(this.w, this.z, this.x);
    private inline function get_wzy()return new Vec3(this.w, this.z, this.y);
}
