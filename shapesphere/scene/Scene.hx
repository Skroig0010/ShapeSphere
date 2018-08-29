package shapesphere.scene;
import shapesphere.camera.Camera;
import shapesphere.math.Vec3;

class Scene{
    public var camera : Camera;

    public function new(){
        camera = new Camera();
    }

    public function setCamera(?position : Vec3, ?lookat : Vec3, ?up : Vec3){
        if(position != null)camera.position = position;
        if(position != null)camera.lookat = lookat;
        if(position != null)camera.up = up;
    }
}
