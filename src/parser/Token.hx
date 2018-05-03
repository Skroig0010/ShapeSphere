package src.parser;

class Token<T>{
    public var kind : T;
    public var offsetBegin : Int;
    public var offsetEnd : Int;
    public var lexeme : String;
    public function new(kind : T, offsetBegin : Int, offsetEnd : Int, lexeme : String){
        this.kind = kind;
        this.offsetBegin = offsetBegin;
        this.offsetEnd = offsetEnd;
        this.lexeme = lexeme;
    }
}
