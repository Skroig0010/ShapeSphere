package shapesphere.graphics.animation;

class AnimationClip{
    public var duaration(default, null) : TimeSpan;
    public var keyFrames(default, null) : Array<KeyFrame>;

    public function new(duaration : TimeSpan, keyFrames : Array<KeyFrame>){
        if(duaration != null && keyFrames != null){
            this.duaration = duaration;
            this.keyFrames = keyFrames;
        }
    }
}
