package shapesphere.camera;
import shapesphere.math.Vec3;

class Camera{
    public var position : Vec3;
    public var lookat : Vec3;
    public var up : Vec3;

    public function new(?position : Vec3, ?lookat : Vec3, ?up : Vec3){
        this.position = switch(position){
            case null:  new Vec3(0, 0, 0);
            default:    position;
        };
        this.lookat = switch(lookat){
            case null:  new Vec3(0, 0, 0);
            default:    lookat;
        };
        this.up = switch(up){
            case null: new Vec3(0, 0, 0);
            default: up;
        };
    }
}
