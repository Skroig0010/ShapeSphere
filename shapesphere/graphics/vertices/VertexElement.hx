package shapesphere.graphics.vertices;

class VertexElement{
    public var offset : Int;
    public var format : VertexElementFormat;
    public var usage : VertexElementUsage;
    public var usageIndex : Int;

    public function new(offset : Int, elementFormat : VertexElementFormat, elementUsage : VertexElementUsage, usageIndex : Int){
        this.offset = offset;
        this.format = elementFormat;
        this.usage = elementUsage;
        this.usageIndex = usageIndex;
    }

    public function equals(other : VertexElement){
        return offset == other.offset
            && format == other.format
            && usage == other.usage
            && usageIndex == other.usageIndex;
    }
}
