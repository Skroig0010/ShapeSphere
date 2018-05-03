package src.graphics;
import js.html.webgl.*;
import src.graphics.vertices.*;

class GraphicsDevice{
    public static var gl:RenderingContext;
    public static var maxVertexAttributes : Int;

    public var vertexBuffer : Buffer;
    public var indexBuffer : Buffer;

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
        gl.viewport(0, 0, canvas.width, canvas.height);

        gl.clearColor(0.0, 0.0, 0.0, 1.0);
        gl.clear(
                RenderingContext.COLOR_BUFFER_BIT |
                RenderingContext.DEPTH_BUFFER_BIT);
        maxVertexAttributes = gl.getParameter(RenderingContext.MAX_VERTEX_ATTRIBS);
    }

    public function resize(width:Int, height:Int){
        gl.canvas.width = width;
        gl.canvas.height = height;
        gl.viewport(0, 0, width, height);
    }

    public function createArrayBuffer(vertices : Array<Float>) : Buffer{
        var buffer = gl.createBuffer();
        gl.bindBuffer(
                RenderingContext.ARRAY_BUFFER, buffer);
        gl.bufferData(
                RenderingContext.ARRAY_BUFFER,
                cast new js.html.Float32Array(cast vertices),
                RenderingContext.STATIC_DRAW);
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
        gl.vertexAttribPointer(location, size, pointerType, normalized, stride, offset);
    }

    public function uniform1i(location : UniformLocation, x : Int){
        gl.uniform1i(location, x);
    }

    public function uniformMatrix4fv(location : UniformLocation, matrix : Array<Float>){
        gl.uniformMatrix4fv(location, false, matrix);
    }

    public function drawElements(mode : Int, offset : Int, count : Int, ?declaration : VertexDeclaration, shader : src.graphics.shader.Shader){
        if(declaration != null){
            declaration.gd = this;
            declaration.apply(shader, offset);
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
