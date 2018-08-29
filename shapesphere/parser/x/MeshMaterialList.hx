package shapesphere.parser.x;

class MeshMaterialList{
    public var faceIndices : Array<Int>;
    public var materials: Array<Material>;

    public function new(faceIndices : Array<Int>, materials : Array<Material>){
        this.faceIndices = faceIndices;
        this.materials = materials;
    }
}
