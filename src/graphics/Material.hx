package src.graphics;
import js.html.webgl.*;
import src.graphics.GraphicsDevice;
import src.math.*;
import src.scene.Scene;

class Material{

    public var shader(default, null):Program;
    var col:Color;
    var dif:Float;
    var amb:Float;
    var spc:Float;
    var tex:Texture;

    var gd : GraphicsDevice;
    var vertexPositionAttr : Int;
    var normalPositionAttr : Int;
    var uvPositionAttr : Int;

    // Uniform変数の適用
    var transMatrixLocation : UniformLocation;
    var viewMatrixLocation : UniformLocation;
    var projMatrixLocation : UniformLocation;


    public function new(gd:GraphicsDevice, shader:Program, col:Color, dif:Float, amb:Float, spc:Float, tex:Texture){
        this.gd = gd;
        this.shader = shader;
        this.col = col;
        this.dif = dif;
        this.amb = amb;
        this.spc = spc;
        this.tex = tex;
        vertexPositionAttr = gd.getAttribLocation(shader, "vPosition");
        normalPositionAttr = gd.getAttribLocation(shader, "vNormal");
        uvPositionAttr = gd.getAttribLocation(shader, "vUv");

        // Uniform変数の適用
        transMatrixLocation = gd.getUniformLocation(shader, "transMatrix");
        viewMatrixLocation = gd.getUniformLocation(shader, "viewMatrix");
        projMatrixLocation = gd.getUniformLocation(shader, "projMatrix");
    }

    public function apply(scene : Scene){
        gd.useProgram(shader);
        // Attribute変数の適用
        gd.vertexAttribPointer(vertexPositionAttr, 3, RenderingContext.FLOAT, false, (3+3+2)*4, 0);
        gd.vertexAttribPointer(normalPositionAttr, 3, RenderingContext.FLOAT, false, (3+3+2)*4, 3*4);
        gd.vertexAttribPointer(uvPositionAttr, 2, RenderingContext.FLOAT, false, (3+3+2)*4, (3+3)*4);

        gd.uniformMatrix4fv(transMatrixLocation, Mat4.identity);
        gd.uniformMatrix4fv(viewMatrixLocation, Mat4.lookAt(scene.camera));
        gd.uniformMatrix4fv(projMatrixLocation, Mat4.perspective(1, Math.PI / 2, 0.1, 5));
    }
}
