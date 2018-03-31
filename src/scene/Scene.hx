package src.scene;
import src.camera.Camera;
import src.math.Vec3;

class Scene{
    public var camera(default, null) : Camera;

    public function new(){
        camera = new Camera();
    }

    public function setCamera(?position : Vec3, ?forward : Vec3, ?up : Vec3){
        if(position != null)camera.position = position;
        if(position != null)camera.forward = forward;
        if(position != null)camera.up = up;
    }
}
