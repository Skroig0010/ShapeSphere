package src.graphics.vertices;
import src.math.Vec3;

class VertexPosition implements VertexType{
    public var position : Vec3;
    public static var vertexDeclaration : VertexDeclaration;
    static var dummy = new VertexPosition(null);
    public function new(position : Vec3){
        if(dummy == null){
            dummy = this;
            init();
        }
        this.position = position;
    }

    static function init(){
        var elements = new Array<VertexElement>();
        elements.push(new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.Position, 0));
        vertexDeclaration = new VertexDeclaration(3, elements);
    }
    public function iterator() : Iterator<Dynamic>{
        return [position].iterator();
    }
}
