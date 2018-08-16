package src.parser.x;


class AnimationKey<T>{
    public var frameNum : Int;
    public var type : KeyType;
    public var key : Array<T>;
    public var changed : Bool;

    public function new(frameNum : Int, key : Array<T>, type : KeyType, changed : Bool){
        this.frameNum = frameNum;
        this.key = key;
        this.type = type;
        this.changed = changed;
    }
}
