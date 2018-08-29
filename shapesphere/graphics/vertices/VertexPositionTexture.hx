package shapesphere.graphics.vertices;
import shapesphere.math.Vec3;
import shapesphere.math.Vec2;

class VertexPositionTexture implements VertexType{
    public var position : Vec3;
    public var textureCoordinate : Vec2;
    public static var vertexDeclaration : VertexDeclaration;
    static var dummy = new VertexPositionTexture(null, null);

    public function new(position : Vec3, textureCoordinate : Vec2){
        if(dummy == null){
            dummy = this;
            init();
        }
        this.position = position;
        this.textureCoordinate = textureCoordinate;
    }

    static function init(){
        var elements = new Array<VertexElement>();
        elements.push(new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.Position, 0));
        elements.push(new VertexElement(12, VertexElementFormat.Vector2, VertexElementUsage.TextureCoordinate, 0));
        vertexDeclaration = new VertexDeclaration(elements);
    }

    public function iterator() : Iterator<Dynamic>{
        var array : Array<Dynamic> = [position, textureCoordinate];
        return array.iterator();
    }
}
