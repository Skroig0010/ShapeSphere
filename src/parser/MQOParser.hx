package src.parser;
import src.graphics.GraphicsDevice;
import src.graphics.Mesh;
import src.graphics.MeshPart;
import src.graphics.Material;
import src.scene.Scene;
import src.graphics.vertices.VertexPositionTexture;
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
        var mesh : Mesh;
        var meshParts = new Array<MeshPart>();
        var materials = new Array<Material>();
        if(!(eatSymbol("Metasequoia") && eatSymbol("Document") &&
                eatSymbol("Format") && eatSymbol("Text") &&
                eatSymbol("Ver") && eatFloat())){
            throw "invalid header";
        }
        do{
            switch(lexer.getToken()){
                case Symbol("Scene") :
                    scene = getScene();
                default :
            }
        }while(lexer.moveNext());

        mesh = getMesh(scene, null, null);
        return new Mqo(scene, mesh, meshParts, materials);
    }

    function getScene() : Scene{
        var position = new Vec3(0, 0, 0);
        var lookat = new Vec3(0, 0, 0);
        var up = new Vec3(0, 0, 0);
        try{
            eatSymbol("Scene");
            if(lexer.getToken().match(LBrace)){
                lexer.moveNext();
            }else{
                throw "Next to Scene must be {";
            }
            while(lexer.moveNext()){
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
                    case RBrace :
                        break;
                    default :
                        continue;
                }
            }
        }catch(msg : String){
            trace("error : " + msg);
        }
        var scene = new Scene();
        scene.setCamera(position, lookat - position, up);
        return scene;

    }

    function skipChunk() : Bool{
        var counter = 0;
        while(lexer.moveNext()){
            if(lexer.getToken().match(LBrace))counter++;
            if(lexer.getToken().match(RBrace)){
                counter--;
                if(counter == 0)break;
            }
        }
        // 次がなかったらfalseが返る
        return lexer.moveNext();
    }

    function getFloat() : Float{
        return switch(lexer.getToken()){
            case FloatVal(f) : 
                lexer.moveNext();
                f;
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

    function getMesh(scene : Scene, vertices : Array<Float>, indices : Array<Int>) : Mesh{
        return new Mesh(gd, scene, vertices, indices);
    }

    function getMaterial() : Material{
        return new Material(gd, null/*shader*/, null/*Color*/, 0.0, 0.0, 0.0, null/*texture*/);
    }

    function getMeshPart(material : Material, parent : Mesh) : MeshPart{
        return new MeshPart(gd, material, 0, 0, parent);
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

    function eatFloat(?f : Float) : Bool{
        switch(lexer.getToken()){
            case FloatVal(x) if(f == null || x == f) :
                lexer.moveNext();
                return true;
            default :
                trace("Missing eat Float(" + f + "). you have to eat " + lexer.getToken());
                return false;
        }
    }

}
