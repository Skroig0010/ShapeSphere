package src.parser;
import src.math.*;

class XMesh{
    public var vertices : Array<Vec3>;
    public var faces : Array<Array<Int>>;
    public var meshMaterialList : XMeshMaterialList;
    public var meshTextureCoords : Array<Vec2>;

    public function new(vertices : Array<Vec3>, faces : Array<Array<Int>>, meshMaterialList : XMeshMaterialList, meshTextureCoords : Array<Vec2>){
        this.vertices = vertices;
        this.faces = faces;
        this.meshMaterialList = meshMaterialList;
        this.meshTextureCoords = meshTextureCoords;
    }
}
