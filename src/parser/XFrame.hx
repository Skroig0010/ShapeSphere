package src.parser;
import src.math.*;

class XFrame{
    public var frames : Array<XFrame>;
    public var mat : Mat4;
    public var mesh : XMesh;
    public var name : String;

    public function new(name : String, frames : Array<XFrame>, mat : Mat4, mesh : XMesh){
        this.name = name;
        this.frames = frames;
        this.mat = mat;
        this.mesh = mesh;
    }
}
