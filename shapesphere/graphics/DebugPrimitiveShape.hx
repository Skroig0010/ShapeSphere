package shapesphere.graphics;
import shapesphere.math.*;

enum DebugPrimitiveShape{
    Point(v : Vec3, size : Int);
    Line(v1 : Vec3, v2 : Vec3);
    Triangle(v1 : Vec3, v2 : Vec3, v3 : Vec3);
    AABB(v1 : Vec3, v2 : Vec3);
}
