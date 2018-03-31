package src.math;
import src.camera.Camera;


@:forward
abstract Mat4(Mat4Data) from Mat4Data to Mat4Data{
    public static var identity(get, never) : Mat4;
    static inline function get_identity()return new Mat4([
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1]);

    public inline function new(?m : Array<Float>)this = new Mat4Data(m);

    @:to
    public function toArray() {
        return this.m;
    }

    @:from
    public static function fromArray(m : Array<Float>){
        return new Mat4(m);
    }

    @:op(-A)
    public static inline function minus(m : Mat4) : Mat4{
        var m2 = new Mat4();
        for(i in 0...16){
            m2.m[i] = - m.m[i];
        }
        return m2;
    }

    @:op(A+B)
    public static inline function add(m1 : Mat4, m2 : Mat4) : Mat4{
        var m3 = new Mat4();
        for(i in 0...16){
            m3.m[i] = m1.m[i] + m2.m[i];
        }
        return m3;
    }

    @:op(A-B) 
    public static inline function sub(m1 : Mat4, m2 : Mat4) : Mat4{
        var m3 = new Mat4();
        for(i in 0...16){
            m3.m[i] = m1.m[i] - m2.m[i];
        }
        return m3;
    }

    @:op(A*B) 
    public static inline function mult(m1 : Mat4, m2 : Mat4) : Mat4{
        var m3 = new Mat4();
        for(i in 0...4){
            for(j in 0...4){
                var temp = 0.0;
                for(k in 0...4){
                    temp += m1.m[i*4 + k] * m2.m[k*4 + j];
                }
                m3.m[i*4+j] = temp;
            }
        }
        return m3;
    }

    @:commutative
    @:op(A*B) 
    public static inline function multScalar(m : Mat4, x : Float) : Mat4{
        var m2 = new Mat4();
        for(i in 0...16){
            m2.m[i] = m.m[i] * x;
        }
        return m2;
    }

    /*@:op(A*B)
    public static inline function multWithVec4(m : Mat4, v : Vec3){
    }*/

    public static inline function translate(v : Vec3)return new Mat4([
          1,   0,   0,   0, 
          0,   1,   0,   0, 
          0,   0,   1,   0,
         v.x, v.y, v.z,   1]);

    public static inline function rotateX(t : Float){
        var s = Math.sin(t);
        var c = Math.cos(t);
        return new Mat4([
            1, 0, 0, 0,
            0, c,-s, 0,
            0, s, c, 0,
            0, 0, 0, 1]);
    }
    
    public static inline function rotateY(t : Float){
        var s = Math.sin(t);
        var c = Math.cos(t);
        return new Mat4([
            c, 0, s, 0,
            0, 1, 0, 0,
           -s, 0, c, 0,
            0, 0, 0, 1]);
    }

    public static inline function rotateZ(t : Float){
        var s = Math.sin(t);
        var c = Math.cos(t);
        return new Mat4([
            c,-s, 0, 0,
            s, c, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1]);
    }

    public static inline function scale(v : Vec3)return new Mat4([
        v.x,   0,   0,   0, 
          0, v.y,   0,   0, 
          0,   0, v.z,   0,
          0,   0,   0,   1]);

    public static inline function lookAt(camera : Camera){
        var eye = camera.position;
        var forward = camera.forward;
        var up = camera.up;
        var side = up.cross(forward).normalize();
        up = forward.cross(side).normalize();
        return new Mat4([
            side.x, up.x, forward.x, 0,
            side.y, up.y, forward.y, 0,
            side.z, up.z, forward.z, 0,
            -eye.dot(side), -eye.dot(up), -eye.dot(forward), 1]);
    }

    public static inline function perspective(asp : Float, fov :Float, near : Float, far : Float){
        var t = Math.tan(fov / 2);
        return new Mat4([
                1 / (asp * t),     0,                               0,  0,
                0            , 1 / t,                               0,  0,
                0            ,     0,     (near + far) / (near - far), -1,
                0            ,     0,   2 * near * far / (near - far),  0]);
    }
}
