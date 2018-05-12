package src.parser;
import src.math.Vec3;

class MqoObject{
    public var vertices : Array<Vec3>;
    public var faces : Array<MqoFace>;
    public var name : String;

    public function new(name : String, vertices : Array<Vec3>, faces : Array<MqoFace>){
        this.vertices = vertices;
        this.faces = faces;
    }
}
