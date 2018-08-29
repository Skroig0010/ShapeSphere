package shapesphere.graphics.vertices;
import shapesphere.math.Vec2;
import shapesphere.math.Vec3;

class VertexPositionNormalTexture implements VertexType{
    public var position : Vec3;
    public var normal : Vec3;
    public var textureCoordinate : Vec2;
    public static var vertexDeclaration : VertexDeclaration;
    static var dummy = new VertexPositionNormalTexture(null, null, null);

    public function new(position : Vec3, normal : Vec3, textureCoordinate : Vec2){
        if(dummy == null){
            dummy = this;
            init();
        }
        this.position = position;
        this.normal = normal;
        this.textureCoordinate = textureCoordinate;
    }

    static function init(){
        var elements = new Array<VertexElement>();
        elements.push(new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.Position, 0));
        elements.push(new VertexElement(12, VertexElementFormat.Vector3, VertexElementUsage.Normal, 0));
        elements.push(new VertexElement(24, VertexElementFormat.Vector2, VertexElementUsage.TextureCoordinate, 0));
        vertexDeclaration = new VertexDeclaration(elements);
    }

    public function iterator() : Iterator<Dynamic>{
        var array : Array<Dynamic> = [position, normal, textureCoordinate];
        return array.iterator();
    }
}
