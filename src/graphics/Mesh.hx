package src.graphics;
import js.html.webgl.*;
import src.math.*;

class Mesh{
    public var id:Int;
    public var scale:Vec3;
    public var rotation:Vec3;
    public var translation:Vec3;
    public var visible:Bool;
    public var meshParts:List<MeshPart>;

    public var indexBuffer(default, null):Buffer;
    public var vertexBuffer(default, null):Buffer;

    var gd : GraphicsDevice;

    public function new(gd : GraphicsDevice, id : Int, vertices : Array<Float>, indices : Array<Int>){
        this.gd = gd;
        this.visible = true;
        vertexBuffer = gd.createArrayBuffer(vertices);
        indexBuffer = gd.createIndexBuffer(indices);
        meshParts = new List<MeshPart>();
    }

    public function render(){
        if(visible){
            gd.setVertexBuffer(vertexBuffer);
            gd.setIndexBuffer(indexBuffer);
            for(part in meshParts){
                part.material.apply();
                gd.drawElements(RenderingContext.TRIANGLES, part.vertexOffset, part.numVertices);
            }
        }
    }
}
