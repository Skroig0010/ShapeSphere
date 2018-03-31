package src.graphics.vertices;
import src.math.Vec3;

class VertexPosition implements VertexType{
    public var position : Vec3;
    @:isVar public var vertexDeclaration(get, null) : VertexDeclaration;

    public function new(){
        var elements = new Array<VertexElement>();
        elements.push(new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.Position, 0));
        var declaration = new VertexDeclaration(3, elements);
    }

    public function get_vertexDeclaration(){
        return vertexDeclaration;
    }
}
