package shapesphere.graphics;
import js.html.webgl.*;
import shapesphere.math.*;
import shapesphere.scene.Scene;
import shapesphere.graphics.vertices.VertexDeclaration;

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

    var vertexDeclaration : VertexDeclaration;

    var gd : GraphicsDevice;

    public function new(gd : GraphicsDevice, name, vertices : Array<Float>, indices : Array<Int>, vertexDeclaration : VertexDeclaration){
        this.gd = gd;
        this.name = name;
        id = maxId++;
        this.visible = true;
        this.vertexDeclaration = vertexDeclaration;
        vertexBuffer = gd.createFloat32ArrayBuffer(vertices);
        indexBuffer = gd.createIndexBuffer(indices);
        meshParts = new List<MeshPart>();
    }

    public function render(world : Mat4, view : Mat4, projection : Mat4){
        if(visible){
            gd.setVertexBuffer(vertexBuffer);
            gd.setIndexBuffer(indexBuffer);
            for(part in meshParts){
                part.material.apply(world, view, projection);
                gd.drawElements(RenderingContext.TRIANGLES, part.vertexOffset, part.numVertices, vertexDeclaration, part.material.shader);
            }
        }
    }
}
