package shapesphere.parser.x;
import shapesphere.math.*;

class SkinWeights{
    public var transformNodeName : String;
    public var nWeights : Int;
    public var vertexIndices : Array<Int>;
    public var weights : Array<Float>;
    public var matrixOffset : Mat4;

    public function new(transformNodeName : String, nWeights : Int, vertexIndices : Array<Int>, weights : Array<Float>, matrixOffset : Mat4){
        this.transformNodeName = transformNodeName;
        this.nWeights = nWeights;
        this.vertexIndices = vertexIndices;
        this.weights = weights;
        this.matrixOffset = matrixOffset;
    }
}
