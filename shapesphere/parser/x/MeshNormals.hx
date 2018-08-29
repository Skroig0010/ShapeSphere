package shapesphere.parser.x;
import shapesphere.math.*;

class MeshNormals{
    public var normals : Array<Vec3>;
    public var faces : Array<Array<Int>>;

    public function new(normals : Array<Vec3>, faces : Array<Array<Int>>){
        this.normals = normals;
        this.faces = faces;
    }
}
