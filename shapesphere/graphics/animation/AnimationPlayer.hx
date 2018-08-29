package shapesphere.graphics.animation;
import shapesphere.math.Mat4;

class AnimationPlayer{
    public var currentClipValue(default, null) : AnimationClip;
    public var currentTimeValue(default, null) : TimeSpan;
    var currentKeyFrame : Int;

    // Current animation transform matrices
    public var boneTransforms(default, null) : Array<Mat4>;
    public var worldTransforms(default, null) : Array<Mat4>;
    public var skinTransforms(default, null) : Array<Mat4>;

    var skinningDataValue : SkinningData;

    public function new(skinningData : SkinningData){
        if(skinningData == null) throw "null skinningData";

        skinningDataValue = skinningData;

        boneTransforms = new Array<Mat4>();
        worldTransforms = new Array<Mat4>();
        skinTransforms = new Array<Mat4>();
    }
    public function startClip(clip : AnimationClip){
        if(clip == null) throw "null clip";

        currentClipValue = clip;
        currentTimeValue = TimeSpan.zero;
        currentKeyFrame = 0;

        boneTransforms = skinningDataValue.bindPose.copy();
    }

    public function update(time : TimeSpan, relativeToCurrentTime : Bool, rootTransform : Mat4){
        updateBoneTransforms(time, relativeToCurrentTime);
        updateWorldTransforms(rootTransform);
        updateSkinTransforms();
    }

    public function updateBoneTransforms(time : TimeSpan, relativeToCurrentTime : Bool){
        if(currentClipValue == null) throw "AnimationPlayer.update was called before StartClip";

        if(relativeToCurrentTime){
            time += currentTimeValue;

            // If we reached the end, loop back to the start.
            while(time >= currentTimeValue.duaration){
                time -= currentClipValue.duaration;
            }
        }

        if((time < TimeSpan.zero) || (time >= currentClipValue.duaration)){
            throw "Out of range : time";
        }

        if(time < currentTimeValue){
            currentKeyFrame = 0;
            boneTransforms = skinningDataValue.bindPose.copy();
        }

        currentTimeValue = time;

        var keyFrames = currentClipValue.keyFrames;

        while(currentKeyFrame < keyFrames.length){
            var keyFrame = keyFrames[currentKeyFrame];

            if(keyFrame.time > currentTimeValue) break;

            boneTransforms[keyFrame.bone.index] = keyFrame.transform;

            currentKeyFrame++;
        }
    }

    public function updateWorldTransforms(rootTransform : Mat4){
        // ここ以下がかけ算の順序が逆だと思う
            // 直したら使ってみてちゃんと動くか調べる
            // 多分ちゃんと動かないのでコードを直す
        worldTransforms[0] = rootTransform * boneTransforms[0];
        for(bone in 0...worldTransforms.length){
            var parentBone = skinningDataValue.skeltonHierarchy[bone];

            worldTransforms[bone] = worldTransforms[parentBone] * boneTransforms[bone];
        }
    }

    public function updateSkinTransforms(){
        for(bone in 0...skinTransforms.length){
            skinTransforms[bone] = worldTransforms[bone] * skinningDataValue.inverseBindPose[bone];
        }
    }
}
