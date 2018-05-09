package src.parser;
import src.graphics.Color;
import src.graphics.GraphicsDevice;
import src.graphics.Mesh;
import src.graphics.MeshPart;
import src.graphics.Material;
import src.graphics.Texture;
import src.graphics.shader.Shader;
import src.graphics.vertices.VertexPositionTexture;
import src.scene.Scene;
import src.math.*;

class MqoParser{
    var lexer : MqoLexer;
    var gd : GraphicsDevice;
    public function new(text : String, gd : GraphicsDevice){
        lexer = new MqoLexer(text);
        this.gd = gd;
    }

    public function getMqo() : Mqo{
        var scene = new Scene();
        var materials = new Array<Material>();
        var objects = new Array<MqoObject>();
        if(!(eatSymbol("Metasequoia") && eatSymbol("Document") &&
                    eatSymbol("Format") && eatSymbol("Text") &&
                    eatSymbol("Ver") && eatFloat())){
            throw "invalid header";
        }
        // try{
            do{
                switch(lexer.getToken()){
                    case Symbol("Scene") :
                        scene = getScene();
                    case Symbol("Material") :
                        eatSymbol("Material");
                        var num = getInt();
                        eatLBrace();
                        for(i in 0...num){
                            materials.push(getMaterial());
                        }
                        eatRBrace();
                    case Symbol("Object") :
                        objects.push(getObject());
                    case Symbol("Thumbnail") :
                        skipChunk();
                    case Symbol("IncludeXml") :
                        eatSymbol();
                        eatString();
                    default :
                        lexer.moveNext();
                }
            }while(lexer.getToken() != null);

        // }catch(msg : String){
        //     trace("error : " + msg);
        // }
        return new Mqo(scene, materials, objects);
    }

    function getObject() : MqoObject{ 
        var vertices = new Array<Vec3>();
        var faces = new Array<MqoFace>();
        eatSymbol("Object");
        eatString();
        eatLBrace();
        while(lexer.getToken() != null){
            switch(lexer.getToken()){
                case Symbol("uid") : eatSymbol();eatInt();
                case Symbol("depth") : eatSymbol();eatInt();
                case Symbol("folding") : eatSymbol();eatInt();
                case Symbol("scale") : eatSymbol();eatFloat();eatFloat();eatFloat();
                case Symbol("rotation") : eatSymbol();eatFloat();eatFloat();eatFloat();
                case Symbol("translation") : eatSymbol();eatFloat();eatFloat();eatFloat();
                case Symbol("patch") : eatSymbol();eatInt();
                case Symbol("patchtri") : eatSymbol();eatInt();
                case Symbol("segment") : eatSymbol();eatInt();
                case Symbol("visible") : eatSymbol();eatInt();
                case Symbol("locking") : eatSymbol();eatInt();
                case Symbol("shading") : eatSymbol();eatInt();
                case Symbol("normal_weight") : eatSymbol();eatFloat();
                case Symbol("facet") : eatSymbol();eatFloat();
                case Symbol("color") : eatSymbol();eatFloat();eatFloat();eatFloat();
                case Symbol("color_type") : eatSymbol();eatInt();
                case Symbol("mirror") : eatSymbol();eatInt();
                case Symbol("mirror_axis") : eatSymbol();eatInt();
                case Symbol("mirror_dis") : eatSymbol();eatFloat();
                case Symbol("lathe") : eatSymbol();eatInt();
                case Symbol("lathe_axis") : eatSymbol();eatInt();
                case Symbol("lathe_seg") : eatSymbol();eatInt();
                case Symbol("vertex") :
                                           eatSymbol();
                                           var num = getInt();
                                           vertices = getVertexChunk(num);
                case Symbol("BVertex") : skipChunk();
                case Symbol("vertexattr") : skipChunk();
                case Symbol("face") :
                                         eatSymbol();
                                         var num = getInt();
                                         faces = getFaceChunk(num);
                case RBrace :
                                         eatRBrace();
                                         break;
                default:
                                         throw "unexpected symbol found :" + lexer.getToken() + " in Object chunk";
            }
        }
        return new MqoObject(vertices, faces);
    }

    function getVertexChunk(num : Int) : Array<Vec3>{
        eatLBrace();
        var vertices = new Array<Vec3>();
        for(i in 0...num){
            vertices.push(new Vec3(getFloat(), getFloat(), getFloat()));
        }
        eatRBrace();
        return vertices;
    }

    function getFaceChunk(num : Int) : Array<MqoFace>{
        eatLBrace();
        var faces = new Array<MqoFace>();
        for(i in 0...num){
            faces.push(getFace());
        }
        eatRBrace();
        return faces;
    }

    function getFace() : MqoFace{
        if(getInt() != 3){
            throw "face vertex number must be 3";
        }
        var indices : Array<Int> = null;
        var material = 0;
        var uv : Array<Vec2> = [new Vec2(0, 0), new Vec2(0, 0), new Vec2(0, 0)];
        var col : Array<Color> = null;
        var crs : Array<Float> = null;
        while(lexer.getToken() != null){
            switch(lexer.getToken()){
                case Symbol("V") :
                    eatSymbol();
                    eatLParen();
                    indices = new Array<Int>();
                    for(j in 0...3){
                        indices.push(getInt());
                    }
                    eatRParen();
                case Symbol("M") :
                    eatSymbol();
                    eatLParen();
                    material = getInt();
                    eatRParen();
                case Symbol("UV") :
                    eatSymbol();
                    eatLParen();
                    uv = new Array<Vec2>();
                    for(j in 0...3){
                        uv.push(new Vec2(getFloat(), getFloat()));
                    }
                    eatRParen();
                case Symbol("COL") :
                    eatSymbol();
                    eatLParen();
                    col = new Array<Color>();
                    for(j in 0...3){
                        var x = getInt();
                        col.push(Rgba(x & 0x000000FF,x & 0x0000FF00,x & 0x00FF0000,   x & 0xFF000000));
                    }
                    eatRParen();
                case Symbol("CRS") :
                    eatSymbol();
                    eatLParen();
                    crs = new Array<Float>();
                    for(j in 0...3){
                        crs.push(getFloat());
                    }
                    eatRParen();
                default :
                    break;
            }
        }
        return new MqoFace(indices, material, uv, col, crs);
    }

    function getScene() : Scene{
        var position = new Vec3(0, 0, 0);
        var lookat = new Vec3(0, 0, 0);
        var up = new Vec3(0, 0, 0);
        eatSymbol("Scene");
        eatLBrace();
        while(lexer.getToken() != null){
            switch(lexer.getToken()){
                case Symbol("pos") :
                    eatSymbol("pos");
                    position = getVec3();
                case Symbol("lookat"):
                    eatSymbol("lookat");
                    lookat = getVec3();
                case Symbol("head"):
                    eatSymbol("head");
                    var head = Mat4.rotateY(getFloat());
                    eatSymbol("pich");
                    var pich = Mat4.rotateX(getFloat());
                    eatSymbol("bank");
                    var bank = Mat4.rotateZ(getFloat());
                    up = new Vec3(0, 1, 0);
                case Symbol("dirlights") :
                    skipChunk();
                case LBrace :
                    skipBraces();
                case RBrace :
                    eatRBrace();
                    break;
                default :
                    lexer.moveNext();
                    continue;
            }
        }
        var scene = new Scene();
        scene.setCamera(position, lookat - position, up);
        return scene;

    }

    function getMaterial() : Material{
        var shader : Shader = null;
        var color : Color = White;
        var dif = 0.0, amb = 0.0, spc = 0.0;
        var tex : Texture = null;
        // 最初のmoveNextでマテリアル名を食べる
        lexer.moveNext();
        while(lexer.getToken() != null){
            switch(lexer.getToken()){
                case Symbol("shader") :
                    eatSymbol();
                    eatLParen();
                    switch(getInt()){
                        case 0 | 1 | 2 | 3 | 4 :
                            shader = gd.shaderProgramCache.getProgram("classic","classic");
                        default :
                            throw "Invalid shader number in material.";
                    }
                    eatRParen();
                case Symbol("col") :
                    eatSymbol();
                    eatLParen();
                    color = Rgba(getFloat(), getFloat(), getFloat(), getFloat());
                    eatRParen();
                case Symbol("dif") :
                    eatSymbol();
                    eatLParen();
                    dif = getFloat();
                    eatRParen();
                case Symbol("amb") :
                    eatSymbol();
                    eatLParen();
                    amb = getFloat();
                    eatRParen();
                case Symbol("spc") :
                    eatSymbol();
                    eatLParen();
                    spc = getFloat();
                    eatRParen();
                case Symbol("emi") :
                    eatSymbol();
                    eatLParen();
                    getFloat();
                    eatRParen();
                case Symbol("power") :
                    eatSymbol();
                    eatLParen();
                    getFloat();
                    eatRParen();
                case Symbol("tex") :
                    eatSymbol();
                    eatLParen();
                    tex = new Texture(getString());
                    eatRParen();
                case StringVal(_) :
                    break;
                case RBrace :
                    break;
                default :
                    lexer.moveNext();
                    trace("Don't match " + lexer.getToken());
            }
        }
        return new Material(gd, shader, color, dif, amb, spc, tex);
    }


    function eatSymbol(?s : String) : Bool{
        switch(lexer.getToken()){
            case Symbol(x) if(s == null || x == s) :
                lexer.moveNext();
                return true;
            default :
                trace("Missing eat Symbol(" + s + "). you have to eat " + lexer.getToken());
                return false;
        }
    }

    function getString() : String{
        return switch(lexer.getToken()){
            case StringVal(s) :
                lexer.moveNext();
                s;
            default : throw "Float cannot found. You found " + lexer.getToken();
        }
    }

    function getFloat() : Float{
        return switch(lexer.getToken()){
            case FloatVal(f) : 
                lexer.moveNext();
                f;
            case IntVal(f) :
                lexer.moveNext();
                f;
            default : throw "Float cannot found. You found " + lexer.getToken();
        }
    }

    function getInt() : Int{
        return switch(lexer.getToken()){
            case IntVal(i) : 
                lexer.moveNext();
                i;
            default : throw "Float cannot found. You found " + lexer.getToken();
        }
    }

    function getVec3() : Vec3{
        var x = switch(lexer.getToken()){
            case FloatVal(f) : f;
            case IntVal(i) : i;
            default : throw "vec3 parameters must be numbers";
        }
        lexer.moveNext();
        var y = switch(lexer.getToken()){
            case FloatVal(f) : f;
            case IntVal(i) : i;
            default : throw "vec3 parameters must be numbers";
        }
        lexer.moveNext();
        var z = switch(lexer.getToken()){
            case FloatVal(f) : f;
            case IntVal(i) : i;
            default : throw "vec3 parameters must be numbers";
        }
        return new Vec3(x, y, z);
    }

    function eatString(?s : String) : Bool{
        switch(lexer.getToken()){
            case StringVal(x) if(s == null || x == s) :
                lexer.moveNext();
                return true;
            default :
                trace("Missing eat String(" + s + "). you have to eat " + lexer.getToken());
                return false;
        }
    }

    // 整数型を1つ食べる。食べられなかったらfalse
    function eatInt(?i : Int) : Bool{
        switch(lexer.getToken()){
            case IntVal(x) if(i == null || x == i) :
                lexer.moveNext();
                return true;
            default :
                trace("Missing eat Int(" + i + "). you have to eat " + lexer.getToken());
                return false;
        }
    }

    // 浮動小数点型を1つ食べる。食べられなかったらfalse
    function eatFloat(?f : Float) : Bool{
        switch(lexer.getToken()){
            case FloatVal(x) if(f == null || x == f) :
                lexer.moveNext();
                return true;
            case IntVal(x) if(f == null || x == f) :
                lexer.moveNext();
                return true;
            default :
                trace("Missing eat Float(" + f + "). you have to eat " + lexer.getToken());
                return false;
        }
    }

    // {を食べる
    function eatLBrace() : Bool{
        switch(lexer.getToken()){
            case LBrace :
                lexer.moveNext();
                return true;
            default :
                trace("Missing eat LBrace. you have to eat " + lexer.getToken());
                return false;
        }
    }

    // (を食べる
    function eatRBrace() : Bool{
        switch(lexer.getToken()){
            case RBrace :
                lexer.moveNext();
                return true;
            default :
                trace("Missing eat RBrace. you have to eat " + lexer.getToken());
                return false;
        }
    }

    // (を食べる
    function eatLParen() : Bool{
        switch(lexer.getToken()){
            case LParen :
                lexer.moveNext();
                return true;
            default :
                trace("Missing eat LParen. you have to eat " + lexer.getToken());
                return false;
        }
    }

    // )を食べる
    function eatRParen() : Bool{
        switch(lexer.getToken()){
            case RParen :
                lexer.moveNext();
                return true;
            default :
                trace("Missing eat LParen. you have to eat " + lexer.getToken());
                return false;
        }
    }

    // 1チャンク飛ばす
    function skipChunk() : Bool{
        lexer.moveNext();
        return skipBraces();
    }

    // {から対応する}まで飛ばす
    function skipBraces() : Bool{
        var counter = 0;
        var xs = new Array<String>();
        do{
            xs.push("token = " + lexer.getToken() + " count = " + counter);
            if(lexer.getToken().match(LBrace))counter++;
            if(lexer.getToken().match(RBrace)){
                counter--;
                if(counter == 0)break;
            }
        }while(lexer.moveNext());
        // 次がなかったらfalseが返る
        return lexer.moveNext();
    }

}
