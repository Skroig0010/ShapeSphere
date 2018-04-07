package src.graphics.vertices;
import src.math.Vec2;
import src.math.Vec3;

class VertexPositionNormalTexture implements VertexType{
    public var position : Vec3;
    public var normal : Vec3;
    public var textureCoordinate : Vec2;
    public static var vertexDeclaration : VertexDeclaration;

    public function new(){
        var elements = new Array<VertexElement>();
        elements.push(new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.Position, 0));
        elements.push(new VertexElement(12, VertexElementFormat.Vector3, VertexElementUsage.Normal, 0));
        elements.push(new VertexElement(24, VertexElementFormat.Vector2, VertexElementUsage.TextureCoordinate, 0));
        vertexDeclaration = new VertexDeclaration(elements);
    }

}
