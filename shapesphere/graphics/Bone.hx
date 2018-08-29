package shapesphere.graphics;
import shapesphere.math.*;

class Bone{
    public var name : String;
    public var children : Array<Bone>;
    public var meshes : Array<Mesh>;
    public var localTransform : Mat4;
    public var modelTransform : Mat4;
    public var parent : Bone;
    public var index : Int;

    public function new(name : String, children : Array<Bone>, localTransform : Mat4, modelTransform : Mat4, parent : Bone, index : Int){
        this.name = name;
        this.children = children;
        this.localTransform = localTransform;
        this.modelTransform = modelTransform;
        this.parent = parent;
        this.index = index;
    }

    public function addMesh(mesh : Mesh){
        meshes.push(mesh);
    }

    public function addChild(bone : Bone){
        children.push(bone);
    }
}
