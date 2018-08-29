package shapesphere.graphics.animation;

@:forward
abstract TimeSpan(Float) from Float to Float{
    public inline function new(duaration : Float)this = duaration;

    public static var zero(get, null) : TimeSpan;
    public var duaration(get, never) : TimeSpan;

    static inline function get_zero(){
        return new TimeSpan(0);
    }

    inline function get_duaration(){
        return this;
    }

    @:op(A+B)
    public static function add(t1 : TimeSpan, t2 : TimeSpan) : TimeSpan;

    @:op(A-B)
    public static function sub(t1 : TimeSpan, t2 : TimeSpan) : TimeSpan;

    @:op(A>B)
    public static function gt(t1 : TimeSpan, t2 : TimeSpan) : Bool;

    @:op(A>=B)
    public static function gteq(t1 : TimeSpan, t2 : TimeSpan) : Bool;

    @:op(A<B)
    public static function lt(t1 : TimeSpan, t2 : TimeSpan) : Bool;

    @:op(A<=B)
    public static function lteq(t1 : TimeSpan, t2 : TimeSpan) : Bool;


}
