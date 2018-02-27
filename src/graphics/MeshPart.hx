package src.graphics;
import js.html.webgl.*;

class MeshPart{
    public var material(default, null):Material;
    public var numVertices(default, null):Int;
    // public var primitiveCount:Int;
    // public var startIndex:Int;
    public var vertexOffset(default, null):Int;
    public var parent(default, null):Mesh;

    public function new(gd : GraphicsDevice, material : Material, numVertices : Int, vertexOffset : Int, parent : Mesh){
        this.material = material;
        this.numVertices = numVertices;
        this.vertexOffset = vertexOffset;
        this.parent = parent;
    }
}
