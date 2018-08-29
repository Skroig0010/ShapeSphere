package shapesphere.graphics.animation;
import shapesphere.math.Mat4;

class SkinningData{
    public var animationClips(default, null) : Map<String, AnimationClip>;
    public var bindPose(default, null) : Array<Mat4>;
    public var inverseBindPose(default, null) : Array<Mat4>;
    public var skeltonHierarchy(default, null) : Array<Int>;

    public function new(animationClips : Map<String, AnimationClip>, bindPose : Array<Mat4>, inverseBindPose : Array<Mat4>, skeltonHierarchy : Array<Int>){
        this.animationClips = animationClips;
        this.bindPose = bindPose;
        this.inverseBindPose = inverseBindPose;
        this.skeltonHierarchy = skeltonHierarchy;

    }

}
