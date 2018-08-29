package shapesphere.graphics.animation;
import shapesphere.math.Mat4;

class KeyFrame{
    public var bone(default, null) : Bone;
    public var time(default, null) : TimeSpan;
    public var transform(default, null) : Mat4;

    public function new(bone : Bone, time : TimeSpan, transform : Mat4){
        this.bone = bone;
        this.time = time;
        this.transform = transform;
    }
}

