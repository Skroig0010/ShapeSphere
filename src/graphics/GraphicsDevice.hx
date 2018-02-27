package src.graphics;
import js.html.webgl.*;

class GraphicsDevice{
    var gl:RenderingContext;

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

    public function createShaderProgram(vertexShaderSource : String, fragmentShaderSource : String) : Program{
        var vertexShader =
            getShader(RenderingContext.VERTEX_SHADER, vertexShaderSource);
        var fragmentShader =
            getShader(RenderingContext.FRAGMENT_SHADER, fragmentShaderSource);

        var shaderProgram = gl.createProgram();
        gl.attachShader(shaderProgram, vertexShader);
        gl.attachShader(shaderProgram, fragmentShader);
        gl.linkProgram(shaderProgram); 

        if(!gl.getProgramParameter(
                    shaderProgram, RenderingContext.LINK_STATUS)) {
            js.Browser.alert('Could not initialize shaders');
        }

        return shaderProgram;
    }

    public function useProgram(program : Program){
        gl.useProgram(program);
    }

    function getShader(shaderType: Int, str: String){
        var shader = gl.createShader(shaderType);

        gl.shaderSource(shader, str);
        gl.compileShader(shader);

        if(!gl.getShaderParameter(shader, RenderingContext.COMPILE_STATUS)) {
            js.Browser.alert(gl.getShaderInfoLog(shader));
            return null;
        }

        return shader;
    }

    public function getAttribLocation(program : Program, name : String){
        var location = gl.getAttribLocation(program, name);
        gl.enableVertexAttribArray(location);
        return location;
    }

    public function vertexAttribPointer(location : Int, size : Int, stride : Int, offset : Int){
        gl.vertexAttribPointer(location, size, RenderingContext.FLOAT, false, stride, offset);
    }

    public function drawElements(mode : Int, offset : Int, count : Int){
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
