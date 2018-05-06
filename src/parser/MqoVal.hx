package src.parser;

enum MqoVal{
    Symbol(s : String);
    IntVal(i : Int);
    FloatVal(f : Float);
    StringVal(s : String);
    LParen; // (
    RParen; // )
    LBrace; // {
    RBrace; // }
}
