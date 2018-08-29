package shapesphere.graphics.vertices;
import shapesphere.math.Vec3;
import shapesphere.math.Vec4;

class VertexPositionColor implements VertexType{
    public var position : Vec3;
    public var color : Vec4;
    public static var vertexDeclaration : VertexDeclaration;
    static var dummy = new VertexPositionColor(null, null);

    public function new(position : Vec3, color : Vec4){
        if(dummy == null){
            dummy = this;
            init();
        }
        this.position = position;
        this.color = color;
    }

    static function init(){
        var elements = new Array<VertexElement>();
        elements.push(new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.Position, 0));
        elements.push(new VertexElement(12, VertexElementFormat.Color, VertexElementUsage.Color, 0));
        vertexDeclaration = new VertexDeclaration(elements);
    }

    public function iterator() : Iterator<Dynamic>{
        var array : Array<Dynamic> = [position, color];
        return array.iterator();
    }
}
