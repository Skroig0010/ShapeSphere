package src.graphics;
import js.html.webgl.RenderingContext;
import js.html.webgl.UniformLocation;
import src.graphics.GraphicsDevice;
import src.graphics.shader.Shader;
import src.math.*;
import src.scene.Scene;

class Material{

    public var shader(default, null):Shader;
    var col:Color;
    var dif:Float;
    var amb:Float;
    var spc:Float;
    var tex:Texture;

    var gd : GraphicsDevice;

    // Uniform変数の適用
    var transMatrixLocation : UniformLocation;
    var viewMatrixLocation : UniformLocation;
    var projMatrixLocation : UniformLocation;
    var textureLocation : UniformLocation;
    var colorLocation : UniformLocation;


    public function new(gd:GraphicsDevice, shader:Shader, col:Color, dif:Float, amb:Float, spc:Float, tex:Texture){
        this.gd = gd;
        this.shader = shader;
        this.col = col;
        this.dif = dif;
        this.amb = amb;
        this.spc = spc;
        this.tex = tex;

        // Uniform変数の適用
        transMatrixLocation = shader.getUniformLocation("transMatrix");
        viewMatrixLocation = shader.getUniformLocation("viewMatrix");
        projMatrixLocation = shader.getUniformLocation("projMatrix");
        colorLocation = shader.getUniformLocation("color");
        if(tex != null){
            textureLocation = shader.getUniformLocation("texture");
        }
    }

    public function apply(scene : Scene){
        shader.useProgram();
        // Textureがあれば設定
        if(tex != null){
            tex.useTexture();
            gd.uniform1i(textureLocation, 0);
        }

        // Uniform変数の設定
        gd.uniformMatrix4fv(transMatrixLocation, false, Mat4.identity);
        gd.uniformMatrix4fv(viewMatrixLocation, false, Mat4.lookAt(scene.camera));
        gd.uniformMatrix4fv(projMatrixLocation, false, Mat4.perspective(1, Math.PI / 2, 0.1, 5));
        var color = switch(col){
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
        gd.uniform4fv(colorLocation, color);
    }
}
