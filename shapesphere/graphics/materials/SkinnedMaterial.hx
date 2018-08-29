package shapesphere.graphics.materials;
import js.html.webgl.RenderingContext;
import js.html.webgl.UniformLocation;
import shapesphere.graphics.shader.Shader;
import shapesphere.math.*;
using shapesphere.graphics.GraphicsExtensions;

class SkinnedMaterial implements IMaterial{

    public var name : String;
    public var shader(default, null):Shader;
    var col : Array<Float>;
    var pow : Float;
    var spc : Array<Float>;
    var emi : Array<Float>;
    var tex : Texture;
    var bones : Array<Bone>;

    var gd : GraphicsDevice;

    // Uniform変数の適用
    var transMatrixLocation : UniformLocation;
    var viewMatrixLocation : UniformLocation;
    var projMatrixLocation : UniformLocation;
    var textureLocation : UniformLocation;
    var colorLocation : UniformLocation;
    var bonesLocation = new Array<UniformLocation>();


    public function new(gd : GraphicsDevice, name : String, shader : Shader, col : Color, pow : Float, spc : Color, emi : Color, tex : Texture, bones : Array<Bone>){
        this.gd = gd;
        this.shader = shader;
        this.name = name;
        this.col = col.toArray();
        this.pow = pow;
        this.spc = spc.toArray();
        this.emi = emi.toArray();
        this.tex = tex;
        this.bones = bones;

        // Uniform変数の適用
        transMatrixLocation = shader.getUniformLocation("transMatrix");
        viewMatrixLocation = shader.getUniformLocation("viewMatrix");
        projMatrixLocation = shader.getUniformLocation("projMatrix");
        colorLocation = shader.getUniformLocation("color");
        for(i in 0...bones.length){
            bonesLocation[i] = shader.getUniformLocation("bones[" + i + "]");
        }
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
        for(i in 0...bones.length){
            gd.uniformMatrix4fv(bonesLocation[i], false, bones[i].modelTransform);
        }
    }
}
