package src.graphics;
import js.html.webgl.*;
import src.graphics.materials.*;

class MeshPart{
    public var material(default, null):IMaterial;
    public var numVertices(default, null):Int;
    // public var primitiveCount:Int;
    // public var startIndex:Int;
    public var vertexOffset(default, null):Int;
    @:isVar public var parent(default, null):Mesh;

    public function new(gd : GraphicsDevice, material : IMaterial, numVertices : Int, vertexOffset : Int, parent : Mesh){
        this.material = material;
        this.numVertices = numVertices;
        this.vertexOffset = vertexOffset;
        this.parent = parent;
    }

    public function setParent(mesh : Mesh){
        if(parent != null){
        parent.meshParts.remove(this);
        }
        parent = mesh;
        parent.meshParts.add(this);
    }
}
