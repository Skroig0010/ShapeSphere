package src.parser;
import src.math.*;

class XAnimation{
    public var boneName : String;
    public var rotationKey : XAnimationKey<Vec4>;
    public var scaleKey : XAnimationKey<Vec3>;
    public var positionKey : XAnimationKey<Vec3>;

    public function new(boneName : String, rotationKey : XAnimationKey<Vec4>, scaleKey : XAnimationKey<Vec3>, positionKey : XAnimationKey<Vec3>){
        this.boneName = boneName;
        this.rotationKey = rotationKey;
        this.scaleKey = scaleKey;
        this.positionKey = positionKey;
    }
}
