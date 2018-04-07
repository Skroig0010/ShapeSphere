package src.graphics.shader;
import src.graphics.GraphicsDevice;
import js.html.webgl.*;

class Shader{
    var program : Program;
    var gl(get, never) : RenderingContext;
    var uniformLocations : Map<String, UniformLocation>;

    function get_gl(){
        return GraphicsDevice.gl;
    }

    public function new(vertexShaderSource : String, fragmentShaderSource : String){
        var vertexShader =
            getShader(RenderingContext.VERTEX_SHADER, vertexShaderSource);
        var fragmentShader =
            getShader(RenderingContext.FRAGMENT_SHADER, fragmentShaderSource);

        program = gl.createProgram();
        gl.attachShader(program, vertexShader);
        gl.attachShader(program, fragmentShader);
        gl.linkProgram(program); 

        if(!gl.getProgramParameter(
                    program, RenderingContext.LINK_STATUS)) {
            js.Browser.alert('Could not initialize shaders');
        }
        uniformLocations = new Map<String, UniformLocation>();
    }

    public function getAttribLocation(name : String){
        var location = gl.getAttribLocation(program, name);
        gl.enableVertexAttribArray(location);
        return location;
    }

    public function getUniformLocation(name : String){
        if(uniformLocations.exists(name)){
            return uniformLocations[name];
        }
        var location = gl.getUniformLocation(program, name);
        uniformLocations.set(name, location);
        return location;
    }

    public function useProgram(){
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

}
