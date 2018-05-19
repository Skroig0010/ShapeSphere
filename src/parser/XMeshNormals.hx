package src.parser;
import src.math.*;

class XMeshNormals{
    public var normals : Array<Vec3>;
    public var faces : Array<Array<Int>>;

    public function new(normals : Array<Vec3>, faces : Array<Array<Int>>){
        this.normals = normals;
        this.faces = faces;
    }
}
