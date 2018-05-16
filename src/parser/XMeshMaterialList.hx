package src.parser;

class XMeshMaterialList{
    public var faceIndices : Array<Int>;
    public var materials: Array<XMaterial>;

    public function new(faceIndices : Array<Int>, materials : Array<XMaterial>){
        this.faceIndices = faceIndices;
        this.materials = materials;
    }
}
