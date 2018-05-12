package src.graphics;
import js.html.Image;
import js.html.webgl.RenderingContext;
import src.graphics.GraphicsDevice;
import src.graphics.states.*;

class Texture{
    public var name : String;
    public var width(default, null) : Int;
    public var height(default, null) : Int;
    public var isNearest : Bool;
    var img : Image;
    var tex : js.html.webgl.Texture;
    inline static var rc = RenderingContext;

    public function new(src : String){
        GraphicsDevice.gl.activeTexture(rc.TEXTURE0);
        var texture = GraphicsDevice.gl.createTexture();
        GraphicsDevice.gl.bindTexture(rc.TEXTURE_2D, texture);
        GraphicsDevice.gl.texImage2D(rc.TEXTURE_2D, 0, rc.RGBA, 1, 1, 0, rc.RGBA, rc.UNSIGNED_BYTE, new js.html.Uint8Array([255, 255, 255, 255]));
        GraphicsDevice.gl.generateMipmap(rc.TEXTURE_2D);
        GraphicsDevice.gl.bindTexture(rc.TEXTURE_2D, null);
        tex = texture;
        img = new Image();
        img.src = src;
        img.onload = function(_){
            GraphicsDevice.gl.bindTexture(rc.TEXTURE_2D, texture);
            GraphicsDevice.gl.texImage2D(rc.TEXTURE_2D, 0, rc.RGBA, rc.RGBA, rc.UNSIGNED_BYTE, img);
            GraphicsDevice.gl.generateMipmap(rc.TEXTURE_2D);
            GraphicsDevice.gl.bindTexture(rc.TEXTURE_2D, null);
        };
    }

    public function setFilter(filter : TextureFilter){
        GraphicsDevice.gl.bindTexture(rc.TEXTURE_2D, tex);
        switch(filter){
            case Linear:
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MAG_FILTER, rc.LINEAR);
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MIN_FILTER, rc.LINEAR);
            case Point:
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MAG_FILTER, rc.NEAREST);
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MIN_FILTER, rc.NEAREST);
            case LinearMipPoint:
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MAG_FILTER, rc.NEAREST);
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MIN_FILTER, rc.NEAREST_MIPMAP_LINEAR);
            case PointMipLinear:
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MAG_FILTER, rc.LINEAR);
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MIN_FILTER, rc.LINEAR_MIPMAP_NEAREST);
            case MinLinearMagPointMipLinear:
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MAG_FILTER, rc.LINEAR);
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MIN_FILTER, rc.LINEAR_MIPMAP_NEAREST);
            case MinLinearMagPointMipPoint:
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MAG_FILTER, rc.NEAREST);
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MIN_FILTER, rc.NEAREST_MIPMAP_NEAREST);
            case MinPointMagLinearMipLinear:
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MAG_FILTER, rc.LINEAR);
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MIN_FILTER, rc.LINEAR_MIPMAP_LINEAR);
            case MinPointMagLinearMipPoint:
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MAG_FILTER, rc.NEAREST);
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_MIN_FILTER, rc.NEAREST_MIPMAP_LINEAR);
            case Anisotropic:
                throw "Anisotropic filter isn't implemented";
        }
        GraphicsDevice.gl.bindTexture(rc.TEXTURE_2D, null);
    }

    public function setAddressMode(mode : TextureAddressMode){
        GraphicsDevice.gl.bindTexture(rc.TEXTURE_2D, tex);
        switch(mode){
            case Wrap:
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_WRAP_S, rc.REPEAT);
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_WRAP_T, rc.REPEAT);
            case Clamp:
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_WRAP_S, rc.CLAMP_TO_EDGE);
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_WRAP_T, rc.CLAMP_TO_EDGE);
            case Mirror:
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_WRAP_S, rc.MIRRORED_REPEAT);
                GraphicsDevice.gl.texParameteri(rc.TEXTURE_2D, rc.TEXTURE_WRAP_T, rc.MIRRORED_REPEAT);

        }
        GraphicsDevice.gl.bindTexture(rc.TEXTURE_2D, null);
    }
    public function setParameterf(pname : Int, param : Float){
        GraphicsDevice.gl.bindTexture(rc.TEXTURE_2D, tex);
        GraphicsDevice.gl.texParameterf(rc.TEXTURE_2D, pname, param);
        GraphicsDevice.gl.bindTexture(rc.TEXTURE_2D, null);
    }

    public function useTexture(){
        GraphicsDevice.gl.bindTexture(rc.TEXTURE_2D, tex);
    }

}
