package src.parser;


class XAnimationKey<T>{
    public var frameNum : Int;
    public var type : XKeyType;
    public var key : Array<T>;
    public var changed : Bool;

    public function new(frameNum : Int, key : Array<T>, type : XKeyType, changed : Bool){
        this.frameNum = frameNum;
        this.key = key;
        this.type = type;
        this.changed = changed;
    }
}
