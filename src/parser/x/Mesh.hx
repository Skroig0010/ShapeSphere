package src.parser.x;
import src.math.*;

class Mesh{
    public var vertices : Array<Vec3>;
    public var faces : Array<Array<Int>>;
    public var meshMaterialList : MeshMaterialList;
    public var meshTextureCoords : Array<Vec2>;
    public var meshNormals : MeshNormals;
    public var skinMeshHeader : XSkinMeshHeader;
    public var skinWeights : SkinWeights;
    public var name : String;

    public function new(name : String, vertices : Array<Vec3>, faces : Array<Array<Int>>, meshMaterialList : MeshMaterialList, meshNormals : MeshNormals, meshTextureCoords : Array<Vec2>, skinMeshHeader : XSkinMeshHeader, skinWeights : SkinWeights){
        this.vertices = vertices;
        this.faces = faces;
        this.meshMaterialList = meshMaterialList;
        this.meshNormals = meshNormals;
        this.meshTextureCoords = meshTextureCoords;
        this.skinMeshHeader = skinMeshHeader;
        this.skinWeights = skinWeights;
    }
}
