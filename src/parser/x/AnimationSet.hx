package src.parser.x;

class AnimationSet{
    public var name : String;
    public var animations : Array<Animation>;

    public function new(name : String, animations : Array<Animation>){
        this.name = name;
        this.animations = animations;
    }
}
