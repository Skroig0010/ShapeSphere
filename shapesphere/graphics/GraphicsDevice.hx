package shapesphere.graphics;
import js.html.webgl.*;
import shapesphere.graphics.vertices.*;
import shapesphere.graphics.shader.ShaderProgramCache;
import shapesphere.graphics.DebugPrimitive;

class GraphicsDevice{
    public static var gl:RenderingContext;
    public static var maxVertexAttributes : Int;

    public var vertexBuffer : Buffer;
    public var indexBuffer : Buffer;

    public var shaderProgramCache : ShaderProgramCache;

    public var debugPrimitive : DebugPrimitive;

    public function new(canvas : js.html.CanvasElement){
        try {
            gl = canvas.getContext("webgl");
            if(gl == null) {
                js.Browser.alert("Could not initialize WebGL");
            }
        }catch(e: Dynamic){
            js.Browser.alert(e);
        }
        gl.enable(RenderingContext.DEPTH_TEST);
        gl.enable(RenderingContext.CULL_FACE);
        // gl.enable(RenderingContext.BLEND);
        // gl.blendFunc(RenderingContext.shapesphere_ALPHA, RenderingContext.ONE_MINUS_SRC_ALPHA);
        gl.viewport(0, 0, canvas.width, canvas.height);

        gl.clearColor(0.0, 0.0, 0.0, 1.0);
        gl.clear(
                RenderingContext.COLOR_BUFFER_BIT |
                RenderingContext.DEPTH_BUFFER_BIT);
        maxVertexAttributes = gl.getParameter(RenderingContext.MAX_VERTEX_ATTRIBS);
        shaderProgramCache = new ShaderProgramCache(this);
        debugPrimitive = new DebugPrimitive(this);

        uniform1i = gl.uniform1i;
        uniform1f = gl.uniform1f;
        uniform4fv = gl.uniform4fv;
        uniformMatrix4fv = gl.uniformMatrix4fv;
    }

    public function resize(width:Int, height:Int){
        gl.canvas.width = width;
        gl.canvas.height = height;
        gl.viewport(0, 0, width, height);
    }

    public function createDynamicBuffer()return gl.createBuffer();

    public function arrayBufferData(buffer, vertices : Array<Float>){
        gl.bindBuffer(RenderingContext.ARRAY_BUFFER, buffer);
        gl.bufferData(RenderingContext.ARRAY_BUFFER, cast new js.html.Float32Array(cast vertices), RenderingContext.DYNAMIC_DRAW);
        gl.bindBuffer(RenderingContext.ARRAY_BUFFER, null);
    }

    public function indexBufferData(buffer, indices : Array<Int>){
        gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, buffer);
        gl.bufferData(RenderingContext.ELEMENT_ARRAY_BUFFER, cast new js.html.Int16Array(cast indices), RenderingContext.DYNAMIC_DRAW);
        gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, null);
    }

    public function createFloat32ArrayBuffer(vertices : Array<Float>) : Buffer{
        var buffer = gl.createBuffer();
        gl.bindBuffer(RenderingContext.ARRAY_BUFFER, buffer);
        gl.bufferData(RenderingContext.ARRAY_BUFFER, cast new js.html.Float32Array(cast vertices), RenderingContext.STATIC_DRAW);
        gl.bindBuffer(RenderingContext.ARRAY_BUFFER, null);
        return buffer;
    }

    public function createIndexBuffer(indices : Array<Int>) : Buffer{
        var buffer = gl.createBuffer();
        gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, buffer);
        gl.bufferData(RenderingContext.ELEMENT_ARRAY_BUFFER, new js.html.Int16Array(cast indices), RenderingContext.STATIC_DRAW);
        gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, null);
        return buffer;
    }

    public function setVertexBuffer(buffer : Buffer){
        gl.bindBuffer(RenderingContext.ARRAY_BUFFER, buffer);
    }
    public function setIndexBuffer(buffer : Buffer){
        gl.bindBuffer(RenderingContext.ELEMENT_ARRAY_BUFFER, buffer);
    }

    public function vertexAttribPointer(location : Int, size : Int, pointerType : Int, normalized : Bool, stride : Int, offset : Int){
        // offsetはデータ数*バイト数しなければならない
        gl.vertexAttribPointer(location, size, pointerType, normalized, stride, offset);
    }

    /*public function uniform1i(location : UniformLocation, x : Int){
        gl.uniform1i(location, x);
    }*/

    public var uniform1i(default, null) : UniformLocation -> Int -> Void;
    public var uniform1f(default, null) : UniformLocation -> Float -> Void;

    public var uniform4fv(default, null) : UniformLocation -> Array<Float> -> Void;

    public var uniformMatrix4fv(default, null) : UniformLocation -> Bool -> Array<Float> -> Void;

    public function drawArrays(mode : Int, first : Int, count : Int, ?declaration : VertexDeclaration, shader : shapesphere.graphics.shader.Shader){
        if(declaration != null){
            declaration.gd = this;
            declaration.apply(shader, 0);
        }
        gl.drawArrays(mode, first, count);
    }
    public function drawElements(mode : Int, offset : Int, count : Int, ?declaration : VertexDeclaration, shader : shapesphere.graphics.shader.Shader){
        if(declaration != null){
            declaration.gd = this;
            declaration.apply(shader, 0);
        }
        gl.drawElements(mode, count, RenderingContext.UNSIGNED_SHORT, offset);
    }

    public function startRender(){
        gl.clearColor(0,0,0,1);
        gl.clear(RenderingContext.COLOR_BUFFER_BIT |
                RenderingContext.DEPTH_BUFFER_BIT );
    }

    public function endRender(){
        gl.flush();
    }
}
