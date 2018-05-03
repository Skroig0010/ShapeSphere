package src.graphics;
import src.graphics.vertices.*;
import js.html.webgl.*;

class GraphicsExtensions{
    public static function numberOfElements(elementFormat : VertexElementFormat){
        switch(elementFormat){
            case VertexElementFormat.Single:
                return 1;

            case VertexElementFormat.Vector2:
                return 2;

            case VertexElementFormat.Vector3:
                return 3;

            case VertexElementFormat.Vector4:
                return 4;

            case VertexElementFormat.Color:
                return 4;

            case VertexElementFormat.Byte4:
                return 4;

            case VertexElementFormat.Short2:
                return 2;

            case VertexElementFormat.Short4:
                return 4;

            case VertexElementFormat.NormalizedShort2:
                return 2;

            case VertexElementFormat.NormalizedShort4:
                return 4;

            case VertexElementFormat.HalfVector2:
                return 2;

            case VertexElementFormat.HalfVector4:
                return 4;
        }
        throw "argument exception";
    }

    public static function vertexAttribPointerType(elementFormat : VertexElementFormat){
        switch(elementFormat){
            case VertexElementFormat.Single:
                return RenderingContext.FLOAT;

            case VertexElementFormat.Vector2:
                return RenderingContext.FLOAT;

            case VertexElementFormat.Vector3:
                return RenderingContext.FLOAT;

            case VertexElementFormat.Vector4:
                return RenderingContext.FLOAT;

            case VertexElementFormat.Color:
                return RenderingContext.UNSIGNED_BYTE;

            case VertexElementFormat.Byte4:
                return RenderingContext.UNSIGNED_BYTE;

            case VertexElementFormat.Short2:
                return RenderingContext.SHORT;

            case VertexElementFormat.Short4:
                return RenderingContext.SHORT;

            case VertexElementFormat.NormalizedShort2:
                return RenderingContext.SHORT;

            case VertexElementFormat.NormalizedShort4:
                return RenderingContext.SHORT;

            case VertexElementFormat.HalfVector2:
                return RenderingContext.LOW_FLOAT;

            case VertexElementFormat.HalfVector4:
                return RenderingContext.LOW_FLOAT;
        }
        throw "argument exception";
    }

    public static function vertexAttribNormalized(element : VertexElement){
        if(element.usage == VertexElementUsage.Color)
            return true;

        switch(element.format){
            case VertexElementFormat.NormalizedShort2:
                return true;
            case VertexElementFormat.NormalizedShort4:
                return true;

            default:
                return false;
        }
    }

    public static function getName(usage : VertexElementUsage){
        switch(usage){
            case VertexElementUsage.Position:
                return "Position";
            case VertexElementUsage.Color:
                return "Color";
            case VertexElementUsage.TextureCoordinate:
                return "TextureCoordinate";
            case VertexElementUsage.Normal:
                return "Normal";
            case VertexElementUsage.Binormal:
                return "Binormal";
            case VertexElementUsage.Tangent:
                return "Tangent";
            case VertexElementUsage.BlendIndices:
                return "BlendIndices";
            case VertexElementUsage.BlendWeight:
                return "BlendWeight";
            case VertexElementUsage.Depth:
                return "Depth";
            case VertexElementUsage.Fog:
                return "Fog";
            case VertexElementUsage.PointSize:
                return "PointSize";
            case VertexElementUsage.Sample:
                return "Sample";
            case VertexElementUsage.TessellateFactor:
                return "TessellateFactor";
        }
        throw "argument exception";
    }

    public static function getSize(elementFormat : VertexElementFormat){
        switch(elementFormat){
            case VertexElementFormat.Single:
                return 4;

            case VertexElementFormat.Vector2:
                return 8;

            case VertexElementFormat.Vector3:
                return 12;

            case VertexElementFormat.Vector4:
                return 16;

            case VertexElementFormat.Color:
                return 4;

            case VertexElementFormat.Byte4:
                return 4;

            case VertexElementFormat.Short2:
                return 4;

            case VertexElementFormat.Short4:
                return 8;

            case VertexElementFormat.NormalizedShort2:
                return 4;

            case VertexElementFormat.NormalizedShort4:
                return 8;

            case VertexElementFormat.HalfVector2:
                return 4;

            case VertexElementFormat.HalfVector4:
                return 8;
        }
        return 0;
    }

}
