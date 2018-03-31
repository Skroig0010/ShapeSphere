package src.graphics;
import js.html.webgl.*;
import src.math.*;
import src.scene.Scene;

class Mesh{
    static var maxId : Int;
    public var id : Int;
    public var scale : Vec3;
    public var rotation : Vec3;
    public var translation : Vec3;
    public var visible : Bool;
    public var meshParts : List<MeshPart>;

    public var indexBuffer(default, null) : Buffer;
    public var vertexBuffer(default, null) : Buffer;

    var gd : GraphicsDevice;
    var scene : Scene;

    public function new(gd : GraphicsDevice, scene : Scene, vertices : Array<Float>, indices : Array<Int>){
        this.gd = gd;
        this.scene = scene;
        id = maxId++;
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
                part.material.apply(scene);
                gd.drawElements(RenderingContext.TRIANGLES, part.vertexOffset, part.numVertices, part.material.shader);
            }
        }
    }
}
