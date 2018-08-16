package src.parser.mqo;
import src.math.Vec2;
import src.graphics.Color;

class Face{
    public var indices : Array<Int>;
    public var material : Int;
    public var uv : Array<Vec2>;
    public var col : Array<Color>;
    public var crs : Array<Float>;

    public function new(indices : Array<Int>, material : Int, uv : Array<Vec2>, col : Array<Color>, crs : Array<Float>){
        this.indices = indices;
        this.material = material;
        this.uv = uv;
        this.col = col;
        this.crs = crs;
    }
}

