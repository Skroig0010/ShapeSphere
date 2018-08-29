package shapesphere.parser.x;
import shapesphere.math.*;

class Animation{
    public var boneName : String;
    public var rotationKey : AnimationKey<Vec4>;
    public var scaleKey : AnimationKey<Vec3>;
    public var positionKey : AnimationKey<Vec3>;

    public function new(boneName : String, rotationKey : AnimationKey<Vec4>, scaleKey : AnimationKey<Vec3>, positionKey : AnimationKey<Vec3>){
        this.boneName = boneName;
        this.rotationKey = rotationKey;
        this.scaleKey = scaleKey;
        this.positionKey = positionKey;
    }
}
