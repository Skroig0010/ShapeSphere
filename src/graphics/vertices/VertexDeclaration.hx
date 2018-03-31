package src.graphics.vertices;
import js.html.webgl.*;
using src.graphics.GraphicsExtensions;

class VertexDeclaration {
    public var vertexStride(default, null) : Int;
    public var elements : Array<VertexElement>;
    public var gd(null, default) : GraphicsDevice;
    var shaderAttributeInfo = new Map<Program, VertexDeclarationAttributeInfo>();

    public function new(?vertexStride : Int, elements : Array<VertexElement>){
        if((elements == null) || (elements.length == 0)){
            throw "Elements cannot be empty";
        }
        this.elements = elements;
        if(vertexStride == null){
            this.vertexStride = getVertexStride(elements);
        }else{
            this.vertexStride = vertexStride;
        }
    }

    function getAttributeInfo(shader : Program){
        var attrInfo = shaderAttributeInfo[shader];
        if(attrInfo == null){
            attrInfo = new VertexDeclarationAttributeInfo(GraphicsDevice.maxVertexAttributes);
            for(ve in elements){
                var attributeLocation = gd.getAttribLocation(shader, ve.usage.getName());
                if(attributeLocation < 0) 
                    continue;

                attrInfo.elements.push(new Element(ve.offset, attributeLocation, ve.format.numberOfElements(), ve.format.vertexAttribPointerType(), ve.vertexAttribNormalized()));
            }

            shaderAttributeInfo[shader] = attrInfo;
        }
        return attrInfo;
    }

    public function apply(shader : Program, offset : Int){
        var attrInfo = getAttributeInfo(shader);
        for(element in attrInfo.elements){
            gd.vertexAttribPointer(element.attributeLocation,
                    element.numberOfElements,
                    element.vertexAttribPointerType,
                    element.normalized,
                    vertexStride,
                    offset + element.offset);
        }
    }

    function getVertexStride(elements : Array<VertexElement>)
    {
        var max = 0;
        for (i in 0...elements.length)
        {
            var start = elements[i].offset + elements[i].format.getSize();
            if (max < start)
                max = start;
        }

        return max;
    }
}

private class VertexDeclarationAttributeInfo{
    public var elements : List<Element>;
    var maxVertexAttributes : Int;
    public function new(maxVertexAttributes : Int){
        this.maxVertexAttributes = maxVertexAttributes;
        elements = new List<Element>();
    }
}

private class Element{
    public var offset : Int;
    public var attributeLocation : Int;
    public var numberOfElements : Int;
    public var vertexAttribPointerType : Int;
    public var normalized : Bool;
    public function new(offset : Int, attributeLocation : Int, numberOfElements : Int, vertexAttribPointerType : Int, normalized : Bool){
        this.offset = offset;
        this.attributeLocation = attributeLocation;
        this.numberOfElements = numberOfElements;
        this.vertexAttribPointerType = vertexAttribPointerType;
        this.normalized = normalized;
    }
}
