package src.parser;
import src.math.Vec3;

class MqoObject{
    var vertices : Array<Vec3>;
    var face : Array<MqoFace>;

    public function new(vertices : Array<Vec3>, face : Array<MqoFace>){
        this.vertices = vertices;
        this.face = face;
    }
}
