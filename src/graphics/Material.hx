package src.graphics;
import js.html.webgl.*;
import src.graphics.GraphicsDevice;

class Material{
    var shader:Program;
    var col:Color;
    var dif:Float;
    var amb:Float;
    var spc:Float;
    var tex:Texture;

    var gd : GraphicsDevice;
    var vertexPositionAttr : Int;
    var normalPositionAttr : Int;
    var uvPositionAttr : Int;

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
    }

    public function apply(){
        gd.useProgram(shader);
        gd.vertexAttribPointer(vertexPositionAttr, 3, (3+3+2)*4, 0);
        gd.vertexAttribPointer(normalPositionAttr, 3, (3+3+2)*4, 3*4);
        gd.vertexAttribPointer(uvPositionAttr, 2, (3+3+2)*4, (3+3)*4);
    }
}
