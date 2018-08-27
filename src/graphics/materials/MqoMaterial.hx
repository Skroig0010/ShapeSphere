package src.graphics.materials;
import js.html.webgl.RenderingContext;
import js.html.webgl.UniformLocation;
import src.graphics.shader.Shader;
import src.math.*;
using src.graphics.GraphicsExtensions;

class MqoMaterial implements IMaterial{

    public var name : String;
    public var shader(default, null):Shader;
    var col:Array<Float>;
    var dif:Float;
    var amb:Float;
    var spc:Float;
    var pow:Float;
    var tex:Texture;

    var gd : GraphicsDevice;

    // Uniform変数の適用
    var transMatrixLocation : UniformLocation;
    var viewMatrixLocation : UniformLocation;
    var projMatrixLocation : UniformLocation;
    var textureLocation : UniformLocation;
    var colorLocation : UniformLocation;


    public function new(gd:GraphicsDevice, name : String, shader:Shader, col:Color, dif:Float, amb:Float, spc:Float, pow : Float, tex:Texture){
        this.gd = gd;
        this.shader = shader;
        this.name = name;
        this.col = col.toArray();
        this.dif = dif;
        this.amb = amb;
        this.spc = spc;
        this.pow = pow;
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

    public function apply(world : Mat4, view : Mat4, projection : Mat4){
        shader.useProgram();
        // Textureがあれば設定
        if(tex != null){
            tex.useTexture();
            gd.uniform1i(textureLocation, 0);
        }

        // Uniform変数の設定
        gd.uniformMatrix4fv(transMatrixLocation, false, world);
        gd.uniformMatrix4fv(viewMatrixLocation, false, view);
        gd.uniformMatrix4fv(projMatrixLocation, false, projection);
        gd.uniform4fv(colorLocation, col);
    }
}
