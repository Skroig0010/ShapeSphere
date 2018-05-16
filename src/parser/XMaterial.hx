package src.parser;
import src.graphics.*;

class XMaterial{
    public var name : String;
    public var color : Color;
    public var power : Float;
    public var spc : Color;
    public var emi : Color;
    public var tex : Texture;

    public function new(name : String, color : Color, power : Float, spc : Color, emi : Color, tex : Texture){
        this.name = name;
        this.color = color;
        this.power = power;
        this.spc = spc;
        this.emi = emi;
        this.tex = tex;
    }
}
