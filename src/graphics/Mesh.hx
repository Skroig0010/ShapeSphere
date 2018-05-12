package src.graphics;
import js.html.webgl.*;
import src.math.*;
import src.scene.Scene;
import src.graphics.vertices.VertexPositionNormalTexture;

class Mesh{
    static var maxId : Int;
    public var name : String;
    public var id : Int;
    public var scale : Vec3;
    public var rotation : Vec3;
    public var translation : Vec3;
    public var visible : Bool;
    public var meshParts : List<MeshPart>;
    public var parentBone : Bone;

    public var indexBuffer(default, null) : Buffer;
    public var vertexBuffer(default, null) : Buffer;

    var gd : GraphicsDevice;

    public function new(gd : GraphicsDevice, name, vertices : Array<Float>, indices : Array<Int>){
        this.gd = gd;
        this.name = name;
        id = maxId++;
        this.visible = true;
        vertexBuffer = gd.createArrayBuffer(vertices);
        indexBuffer = gd.createIndexBuffer(indices);
        meshParts = new List<MeshPart>();
    }

    public function render(world : Mat4, view : Mat4, projection : Mat4){
        if(visible){
            gd.setVertexBuffer(vertexBuffer);
            gd.setIndexBuffer(indexBuffer);
            for(part in meshParts){
                part.material.apply(world, view, projection);
                gd.drawElements(RenderingContext.TRIANGLES, part.vertexOffset, part.numVertices, VertexPositionNormalTexture.vertexDeclaration, part.material.shader);
            }
        }
    }
}
