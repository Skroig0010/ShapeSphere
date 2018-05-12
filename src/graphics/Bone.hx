package src.graphics;
import src.math.*;

class Bone{
    public var name : String;
    public var children : Array<Bone>;
    public var localTransform : Mat4;
    public var modelTransform : Mat4;
    public var parent : Bone;
    public var index : Int;

    public function new(){
        this.parent = null;
    }
}
