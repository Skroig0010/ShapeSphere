package shapesphere.parser.x;

enum Val{
    Symbol(s : String);
    IntVal(i : Int);
    FloatVal(f : Float);
    StringVal(s : String);
    LBrace; // {
    RBrace; // }
    SemiColon; // ;
    Comma; // ,
    Tag(s : String); // <>で囲まれるタグ
}
