package shapesphere.parser.x;
import shapesphere.math.*;

class Frame{
    public var frames : Array<Frame>;
    public var mat : Mat4;
    public var mesh : Mesh;
    public var name : String;

    public function new(name : String, frames : Array<Frame>, mat : Mat4, mesh : Mesh){
        this.name = name;
        this.frames = frames;
        this.mat = mat;
        this.mesh = mesh;
    }
}
