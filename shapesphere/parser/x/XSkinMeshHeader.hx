package shapesphere.parser.x;

class XSkinMeshHeader{
    public var nMaxSkinWeightsPerVertex : Int;
    public var nMaxSkinWeightsPerFace : Int;
    public var nBones : Int;

    public function new(nMaxSkinWeightsPerVertex : Int, nMaxSkinWeightsPerFace : Int, nBones : Int){
        this.nMaxSkinWeightsPerVertex = nMaxSkinWeightsPerVertex;
        this.nMaxSkinWeightsPerFace = nMaxSkinWeightsPerFace;
        this.nBones = nBones;
    }
}
