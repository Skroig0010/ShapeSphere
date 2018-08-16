package src.parser.x;
// import src.graphics.*;
import src.graphics.Color;
import src.graphics.Texture;

import src.math.*;


class Parser{
    var lexer : Lexer;
    public function new(text : String){
        lexer = new Lexer(text);
    }

    public function getX() : X{
        if(!eatSymbol("xof")){
            throw "Invalid header.";
        }
        if(!eatInt(303)){
            trace("Different version number.It may not load correctly.");
        }
        if(!eatSymbol("txt")){
            throw "Invalid file type.";
        }
        if(!eatInt(32)){
            trace("64bit floating point number type will be cast 32bit.");
        }
        var frame : Frame = null;
        var animationSet : AnimationSet = null;
        while(lexer.getToken() != null){
            switch(lexer.getToken()){
                case Symbol("Frame") :
                    frame = getFrame();
                case Symbol("AnimationSet") :
                    animationSet = getAnimationSet();
                default :
                    skipDataObject();
            }
        }
        return new X(frame, animationSet);
    }

    function getAnimationSet() : AnimationSet{
        eatSymbol("AnimationSet");
        var name = getSymbol();
        var animations = new Array<Animation>();

        eatLBrace();

        while(lexer.getToken() != null){
            switch(lexer.getToken()){
                case Symbol("Animation") : 
                    animations.push(getAnimation());
                case RBrace :
                    eatRBrace();
                    break;
                default :
                    throw "Unexpected val in frame : " + lexer.getToken();
            }
        }
        return new AnimationSet(name, animations);
    }
    function getAnimation() : Animation{
        eatSymbol("Animation");
        eatLBrace();
        var boneName : String = "";
        var rotationKey : AnimationKey<Vec4> = null;
        var scaleKey : AnimationKey<Vec3> = null;
        var positionKey : AnimationKey<Vec3> = null;
        while(lexer.getToken() != null){
            switch(lexer.getToken()){
                case LBrace :
                    eatLBrace();
                    boneName = getSymbol();
                    eatRBrace();
                case Symbol("AnimationKey") :
                    var key = getAnimationKey();
                    switch(key.type){
                        case Rotation :
                            rotationKey = cast(key);
                        case Scale :
                            scaleKey = cast(key);
                        case Position :
                            positionKey = cast(key);
                    }
                case RBrace :
                    eatRBrace();
                    break;
                default :
                    throw "Unexpected val in frame : " + lexer.getToken();
            }
        }
        return new Animation(boneName, rotationKey, scaleKey, positionKey);
    }

    function getAnimationKey() : AnimationKey<Dynamic>{
        eatSymbol("AnimationKey");
        eatLBrace();
        var type = switch(getInt()){
            case 0 : KeyType.Rotation;
            case 1 : KeyType.Scale;
            case 2 : KeyType.Position;
            default : throw "matrix type key does not implemented.";
        };
        eatSemiColon();
        var frameNum = getInt();eatSemiColon();
        var changed = false;
        var keys = new Array<Dynamic>();
        for(i in 0...frameNum){
            if(i != getInt()) throw "Keyframe number must correspond nKeys.";
            eatSemiColon();
            keys.push(switch(type){
                case KeyType.Rotation : 
                    if(4 != getInt()) throw "unexpected error.";
                    eatSemiColon();
                    var t = getFloat();eatComma();
                    var x = getFloat();eatComma();
                    var y = getFloat();eatComma();
                    var z = getFloat();eatSemiColon();
                    var v = new Vec4(t, x, y, z);
                    if (i != 0 && keys[0] != v)changed = true;
                    v;
                case KeyType.Scale :
                    if(3 != getInt()) throw "unexpected error";
                    eatSemiColon();
                    var x = getFloat();eatComma();
                    var y = getFloat();eatComma();
                    var z = getFloat();eatSemiColon();
                    var v = new Vec3(x, y, z);
                    if (i != 0 && keys[0] != v)changed = true;
                    v;
                case KeyType.Position :
                    if(3 != getInt()) throw "unexpected error";
                    eatSemiColon();
                    var x = getFloat();eatComma();
                    var y = getFloat();eatComma();
                    var z = getFloat();eatSemiColon();
                    var v = new Vec3(x, y, z);
                    if (i != 0 && keys[0] != v)changed = true;
                    v;
            });
            eatSemiColon();
            if(i != frameNum - 1){
                eatComma();
            }
        }
        eatSemiColon();
        eatRBrace();
        return new AnimationKey(frameNum, keys, type, changed);
    }

    function getFrame() : Frame{
        eatSymbol("Frame");
        var name = getSymbol();
        var frames = new Array<Frame>();
        var mat : Mat4 = null;
        var mesh : Mesh = null;

        eatLBrace();

        while(lexer.getToken() != null){
            switch(lexer.getToken()){
                case Symbol("Frame") :
                    frames.push(getFrame());
                case Symbol("FrameTransformMatrix") :
                    eatSymbol();
                    eatLBrace();
                    mat = getMat4();
                    eatSemiColon();
                    eatRBrace();
                case Symbol("Mesh") :
                    mesh = getMesh();
                case RBrace :
                    eatRBrace();
                    break;
                default :
                    throw "Unexpected val in frame : " + lexer.getToken();
            }
        }
        return new Frame(name, frames, mat, mesh);
    }

    function getMesh() : Mesh{
        eatSymbol("Mesh");
        eatLBrace();

        // 頂点読み込み
        var vertexNum = getInt(); eatSemiColon();
        var vertices = new Array<Vec3>();
        for(i in 0...vertexNum){
            vertices.push(getVec3());
            if(i != vertexNum - 1){
                eatComma();
            }
        }
        eatSemiColon();

        // Face読み込み
        var faceNum = getInt();
        var faces = new Array<Array<Int>>();
        eatSemiColon();
        for(i in 0...faceNum){
            if(!eatInt(3)){
                throw "face vertex number must be 3";
            }
            eatSemiColon();
            var indices = new Array();
            for(j in 0...3){
                indices.push(getInt());
                if(j != 2)eatComma();
            }
            eatSemiColon();
            if(i != faceNum - 1)eatComma();

            faces.push(indices);
        }
        eatSemiColon();

        // 他のデータオブジェクト読み込み
        var matList : MeshMaterialList = new MeshMaterialList(new Array(), new Array());
        var texCoords : Array<Vec2> = null;
        var normals : MeshNormals = null;
        while(lexer.getToken() != null){
            switch(lexer.getToken()){
                case Symbol("MeshMaterialList") : // MeshMaterialList読み込み
                    matList = getMeshMaterialList();
                case Symbol("MeshTextureCoords") : // MeshTextureCoords読み込み
                    texCoords = getMeshTextureCoords();
                case Symbol("MeshNormals") :
                    normals = getMeshNormals();
                case RBrace :
                    eatRBrace();
                    break;
                default : // 必要ないデータオブジェクトは捨てる
                    skipDataObject();
            }
        }
        return new Mesh(vertices, faces, matList, normals, texCoords);
    }

    function getMeshNormals() : MeshNormals{
        eatSymbol("MeshNormals");
        eatLBrace();
        var numNormal = getInt();
        eatSemiColon();
        var normals = new Array<Vec3>();
        for(i in 0...numNormal){
            normals.push(getVec3());
            if(i != numNormal - 1){
                eatComma();
            }
        }
        eatSemiColon();

        var numFace = getInt();
        eatSemiColon();
        var faces = new Array<Array<Int>>();
        for(i in 0...numFace){
            if(getInt() != 3){
                throw "face vertex number must be 3";
            }
            eatSemiColon();
            var face = new Array<Int>();
            for(j in 0...3){
                face.push(getInt());
                if(j != 2)eatComma();
            }
            eatSemiColon();
            faces.push(face);
            if(i != numFace - 1){
                eatComma();
            }
        }
        eatSemiColon();
        eatRBrace();
        return new MeshNormals(normals, faces);
    }

    function getMeshTextureCoords() : Array<Vec2>{
        eatSymbol("MeshTextureCoords");
        eatLBrace();

        var numUv = getInt(); eatSemiColon();
        var uvs = new Array<Vec2>();

        for(i in 0...numUv){
            var x = getFloat(); eatSemiColon();
            var y = getFloat(); eatSemiColon();
            uvs.push(new Vec2(x, y));
            if(i != numUv - 1){
                eatComma();
            }
        }
        eatSemiColon();
        eatRBrace();
        return uvs;
    }

    function getMeshMaterialList() : MeshMaterialList{
        eatSymbol("MeshMaterialList");
        eatLBrace();
        var matNum = getInt();
        eatSemiColon();
        var faceNum = getInt();
        eatSemiColon();
        var faceIndices = new Array<Int>();
        var materials = new Array<Material>();

        // face読み込み
        for(i in 0...faceNum){
            faceIndices.push(getInt());
            if(i != faceNum - 1){
                eatComma();
            }
        }
        eatSemiColon();

        // Material読み込み
        for(i in 0...matNum){
            materials.push(getMaterial());
        }
        eatRBrace();
        return new MeshMaterialList(faceIndices, materials);
    }

    function getMaterial() : Material{
        eatSymbol("Material");

        var name = getSymbol();
        eatLBrace();

        var r = getFloat(); eatSemiColon();
        var g = getFloat(); eatSemiColon();
        var b = getFloat(); eatSemiColon();
        var a = getFloat(); eatSemiColon();
        eatSemiColon();
        var color = Color.Rgba(r, g, b, a);

        var pow = getFloat();
        eatSemiColon();

        r = getFloat(); eatSemiColon();
        g = getFloat(); eatSemiColon();
        b = getFloat(); eatSemiColon();
        eatSemiColon();
        var spc = Color.Rgb(r, g, b);

        r = getFloat(); eatSemiColon();
        g = getFloat(); eatSemiColon();
        b = getFloat(); eatSemiColon();
        eatSemiColon();
        var emi = Color.Rgb(r, g, b);

        var tex : Texture = null;
        if(eatSymbol("TextureFilename")){
            eatLBrace();
            tex = new Texture(getString());
            eatSemiColon();
            eatRBrace();
        }
        eatRBrace();

        return new Material(name, color, pow, spc, emi, tex);
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

    function getSymbol() : String{
        return switch(lexer.getToken()){
            case Symbol(s) :
                lexer.moveNext();
                s;
            default : throw "Symbol doesn't found. You got " + lexer.getToken();
        }
    }

    function getString() : String{
        return switch(lexer.getToken()){
            case StringVal(s) :
                lexer.moveNext();
                s;
            default : throw "String didn't found. You got " + lexer.getToken();
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
            default : throw "Float didn't found. You got " + lexer.getToken();
        }
    }

    function getInt() : Int{
        return switch(lexer.getToken()){
            case IntVal(i) : 
                lexer.moveNext();
                i;
            default : throw "Int didn't found. You got " + lexer.getToken();
        }
    }

    function getVec3() : Vec3{
        var x = getFloat();
        eatSemiColon();
        var y = getFloat();
        eatSemiColon();
        var z = getFloat();
        eatSemiColon();
        return new Vec3(x, y, z);
    }

    function getVec4() : Vec4{
        var x = getFloat();
        eatSemiColon();
        var y = getFloat();
        eatSemiColon();
        var z = getFloat();
        eatSemiColon();
        var w = getFloat();
        eatSemiColon();
        return new Vec4(x, y, z, w);
    }

    function getScaleOrPosition() : Vec3{
        var x = getFloat();
        eatComma();
        var y = getFloat();
        eatComma();
        var z = getFloat();
        eatSemiColon();
        return new Vec3(x, y, z);
    }

    function getQuaternion() : Vec4{
        var x = getFloat();
        eatComma();
        var y = getFloat();
        eatComma();
        var z = getFloat();
        eatComma();
        var w = getFloat();
        eatSemiColon();
        return new Vec4(x, y, z, w);
    }

    function getMat4() : Mat4{
        var m = new Array<Float>();
        for(i in 0...16){
            m.push(getFloat());
            if(i != 15){
                eatComma();
            }
        }
        eatSemiColon();
        return m;
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

    // }を食べる
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

    function eatSemiColon() : Bool{
        switch(lexer.getToken()){
            case SemiColon :
                lexer.moveNext();
                return true;
            default :
                trace("Missing eat SemiColon. you have to eat " + lexer.getToken());
                return false;
        }
    }

    function eatComma() : Bool{
        switch(lexer.getToken()){
            case Comma :
                lexer.moveNext();
                return true;
            default :
                trace("Missing eat Comma. you have to eat " + lexer.getToken());
                return false;
        }
    }

    // データオブジェクトを1つ飛ばす
    function skipDataObject() : Bool{
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
