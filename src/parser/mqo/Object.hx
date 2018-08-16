package src.parser.mqo;
import src.math.Vec3;

class Object{
    public var vertices : Array<Vec3>;
    public var faces : Array<Face>;
    public var name : String;

    public function new(name : String, vertices : Array<Vec3>, faces : Array<Face>){
        this.vertices = vertices;
        this.faces = faces;
    }
}
