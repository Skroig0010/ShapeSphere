package src.parser;

class XAnimationSet{
    public var name : String;
    public var animations : Array<XAnimation>;

    public function new(name : String, animations : Array<XAnimation>){
        this.name = name;
        this.animations = animations;
    }
}
