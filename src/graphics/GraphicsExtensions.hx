package src.graphics;
import src.graphics.vertices.*;
import js.html.webgl.*;
import src.math.*;

class GraphicsExtensions{
    public static function numberOfElements(elementFormat : VertexElementFormat){
        return switch(elementFormat){
            case VertexElementFormat.Single: 1;

            case VertexElementFormat.Vector2: 2;

            case VertexElementFormat.Vector3: 3;

            case VertexElementFormat.Vector4: 4;

            case VertexElementFormat.Color: 4;

            case VertexElementFormat.Byte4: 4;

            case VertexElementFormat.Short2: 2;

            case VertexElementFormat.Short4: 4;

            case VertexElementFormat.NormalizedShort2: 2;

            case VertexElementFormat.NormalizedShort4: 4;

            case VertexElementFormat.HalfVector2: 2;

            case VertexElementFormat.HalfVector4: 4;
            default : throw "argument exception";
        }
    }

    public static function vertexAttribPointerType(elementFormat : VertexElementFormat){
        return switch(elementFormat){
            case VertexElementFormat.Single: RenderingContext.FLOAT;

            case VertexElementFormat.Vector2: RenderingContext.FLOAT;

            case VertexElementFormat.Vector3: RenderingContext.FLOAT;

            case VertexElementFormat.Vector4: RenderingContext.FLOAT;

            case VertexElementFormat.Color: RenderingContext.FLOAT;

            case VertexElementFormat.Byte4: RenderingContext.UNSIGNED_BYTE;

            case VertexElementFormat.Short2: RenderingContext.SHORT;

            case VertexElementFormat.Short4: RenderingContext.SHORT;

            case VertexElementFormat.NormalizedShort2: RenderingContext.SHORT;

            case VertexElementFormat.NormalizedShort4: RenderingContext.SHORT;

            case VertexElementFormat.HalfVector2: RenderingContext.LOW_FLOAT;

            case VertexElementFormat.HalfVector4: RenderingContext.LOW_FLOAT;
            default : throw "argument exception";
        }
    }

    public static function vertexAttribNormalized(element : VertexElement){
        if(element.usage == VertexElementUsage.Color)
            return true;

        return switch(element.format){
            case VertexElementFormat.NormalizedShort2: true;
            case VertexElementFormat.NormalizedShort4: true;
            default: false;
        }
    }

    public static function getName(usage : VertexElementUsage){
        return switch(usage){
            case VertexElementUsage.Position: "Position";
            case VertexElementUsage.Color: "Color";
            case VertexElementUsage.TextureCoordinate: "TextureCoordinate";
            case VertexElementUsage.Normal: "Normal";
            case VertexElementUsage.Binormal: "Binormal";
            case VertexElementUsage.Tangent: "Tangent";
            case VertexElementUsage.BlendIndices: "BlendIndices";
            case VertexElementUsage.BlendWeight: "BlendWeight";
            case VertexElementUsage.Depth: "Depth";
            case VertexElementUsage.Fog: "Fog";
            case VertexElementUsage.PointSize: "PointSize";
            case VertexElementUsage.Sample: "Sample";
            case VertexElementUsage.TessellateFactor: "TessellateFactor";
        }
        throw "argument exception";
    }

    public static function getSize(elementFormat : VertexElementFormat){
        return switch(elementFormat){
            case VertexElementFormat.Single: 4;

            case VertexElementFormat.Vector2: 8;

            case VertexElementFormat.Vector3: 12;

            case VertexElementFormat.Vector4: 16;

            case VertexElementFormat.Color: 16;

            case VertexElementFormat.Byte4: 4;

            case VertexElementFormat.Short2: 4;

            case VertexElementFormat.Short4: 8;

            case VertexElementFormat.NormalizedShort2: 4;

            case VertexElementFormat.NormalizedShort4: 8;

            case VertexElementFormat.HalfVector2: 4;

            case VertexElementFormat.HalfVector4: 8;
        }
    }
    public static function toArray(color : Color){
        return switch(color){
            case Red :
                [1.0, 0.0, 0.0, 1.0];
            case Green :
                [0.0, 1.0, 0.0, 1.0];
            case Blue :
                [0.0, 0.0, 1.0, 1.0];
            case Black :
                [0.0, 0.0, 0.0, 1.0];
            case White :
                [1.0, 1.0, 1.0, 1.0];
            case Clear :
                [0.0, 0.0, 0.0, 0.0];
            case Rgb(r, g, b) :
                [r, g, b, 1.0];
            case Rgba(r, g, b, a) :
                [r, g, b, a];
        }
    }

    public static function toVec4(color : Color){
        return switch(color){
            case Red :
                new Vec4(1.0, 0.0, 0.0, 1.0);
            case Green :
                new Vec4(0.0, 1.0, 0.0, 1.0);
            case Blue :
                new Vec4(0.0, 0.0, 1.0, 1.0);
            case Black :
                new Vec4(0.0, 0.0, 0.0, 1.0);
            case White :
                new Vec4(1.0, 1.0, 1.0, 1.0);
            case Clear :
                new Vec4(0.0, 0.0, 0.0, 0.0);
            case Rgb(r, g, b) :
                new Vec4(r, g, b, 1.0);
            case Rgba(r, g, b, a) :
                new Vec4(r, g, b, a);
        }
    }

}
