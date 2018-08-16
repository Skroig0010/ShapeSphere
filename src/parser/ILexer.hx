package src.parser;

interface ILexer<T>{
    
    public function getToken() : T;
    public function moveNext() : Bool;

}
