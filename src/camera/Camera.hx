package src.camera;
import src.math.Vec3;

class Camera{
    public var position : Vec3;
    public var forward : Vec3;
    public var up : Vec3;

    public function new(?position : Vec3, ?forward : Vec3, ?up : Vec3){
        this.position = switch(position){
            case null:  new Vec3(0, 0, 0);
            default:    position;
        };
        this.forward = switch(forward){
            case null:  new Vec3(0, 0, 0);
            default:    forward;
        };
        this.up = switch(up){
            case null: new Vec3(0, 0, 0);
            default: up;
        };
    }
}
