package src.parser.x;
import src.math.*;

class Mesh{
    public var vertices : Array<Vec3>;
    public var faces : Array<Array<Int>>;
    public var meshMaterialList : MeshMaterialList;
    public var meshTextureCoords : Array<Vec2>;
    public var meshNormals : MeshNormals;

    public function new(vertices : Array<Vec3>, faces : Array<Array<Int>>, meshMaterialList : MeshMaterialList, meshNormals : MeshNormals, meshTextureCoords : Array<Vec2>){
        this.vertices = vertices;
        this.faces = faces;
        this.meshMaterialList = meshMaterialList;
        this.meshNormals = meshNormals;
        this.meshTextureCoords = meshTextureCoords;
    }
}
