package shapesphere.graphics.vertices;
import js.html.*;
import shapesphere.math.Vec2;
import shapesphere.math.Vec3;

class VertexPositionNormalTextureWeights implements VertexType{
    public var position : Vec3;
    public var normal : Vec3;
    public var textureCoordinate : Vec2;
    public var indices : Array<Float>;
    public var weights : Array<Float>;
    public static var vertexDeclaration : VertexDeclaration;
    static var dummy = new VertexPositionNormalTextureWeights(null, null, null,null,null);

    public function new(position : Vec3, normal : Vec3, textureCoordinate : Vec2, indices : Array<Float>, weights : Array<Float>){
        if(dummy == null){
            dummy = this;
            init();
        }
        if(indices != null && indices.length != 4){
            throw "indices.length must be 4";
        }
        if(weights != null && weights.length != 4){
            throw "weights.length must be 4";
        }
        this.position = position;
        this.normal = normal;
        this.textureCoordinate = textureCoordinate;
        this.indices = indices;
        this.weights = weights;
    }

    static function init(){
        var elements = new Array<VertexElement>();
        elements.push(new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.Position, 0));
        elements.push(new VertexElement(12, VertexElementFormat.Vector3, VertexElementUsage.Normal, 0));
        elements.push(new VertexElement(24, VertexElementFormat.Vector2, VertexElementUsage.TextureCoordinate, 0));
        elements.push(new VertexElement(32, VertexElementFormat.Vector4, VertexElementUsage.BlendIndices, 0));
        elements.push(new VertexElement(48, VertexElementFormat.Vector4, VertexElementUsage.BlendWeight, 0));
        vertexDeclaration = new VertexDeclaration(elements);
    }

    public function iterator() : Iterator<Dynamic>{
        /*// Short型をWordにむりやり変換(もっといい方法があったら教えて欲しい)
        var tempView = new DataView(new Uint8Array(indices).buffer);
        var indicesArray = [tempView.getFloat32(0, true)];
        var array : Array<Dynamic> = [position, normal, textureCoordinate, indicesArray, weights];
        */
        // とりあえず頂点インデックスをvec4にして、あとで直す
        var array : Array<Dynamic> = [position, normal, textureCoordinate, indices, weights];
        return array.iterator();
    }
}
