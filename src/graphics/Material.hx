package src.graphics;
import js.html.webgl.RenderingContext;
import js.html.webgl.Texture;
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
    }

    public function apply(scene : Scene){
        shader.useProgram();

        // Uniform変数の設定
        gd.uniformMatrix4fv(transMatrixLocation, Mat4.identity);
        gd.uniformMatrix4fv(viewMatrixLocation, Mat4.lookAt(scene.camera));
        gd.uniformMatrix4fv(projMatrixLocation, Mat4.perspective(1, Math.PI / 2, 0.1, 5));
    }
}
