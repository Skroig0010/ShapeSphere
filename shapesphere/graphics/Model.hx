package shapesphere.graphics;

import shapesphere.math.*;

class Model{
    var gd : GraphicsDevice;
    public var meshes(default, null) : Array<Mesh>;
    public var bones(default, null) : Array<Bone>;
    public var root : Bone;
    public var tag : String;
    static var sharedDrawBoneMatrices : Array<Mat4>;

    public function new(gd : GraphicsDevice, meshes : Array<Mesh>, bones : Array<Bone>){
        this.gd = gd;
        this.meshes = meshes;
        this.bones = bones;
        if(sharedDrawBoneMatrices == null){
            sharedDrawBoneMatrices = new Array<Mat4>();
        }
    }

    public function buildHierarchy(){
        var globalScale = Mat4.scale(new Vec3(0.01, 0.01, 0.01));

        for(node in root.children){
            buildHierarchy2(node, globalScale * root.localTransform, 0);
        }
    }

    function buildHierarchy2(node : Bone, parentTransform : Mat4, level : Int){
        node.modelTransform = parentTransform * node.localTransform;

        for(child in node.children){
            buildHierarchy2(child, node.modelTransform, level + 1);
        }
    }

    public function render(world : Mat4, view : Mat4, projection : Mat4){
        //copyAbsoluteBoneTransformsTo(sharedDrawBoneMatrices);
        for(mesh in meshes){
            mesh.render(world/* * sharedDrawBoneMatrices[mesh.parentBone.index]*/, view, projection);
        }
    }

    public function copyAbsoluteBoneTransformsTo(destinationBoneTransforms : Array<Mat4>){
        for(i in 0...bones.length){
            var bone = bones[i];
            if(bone.parent == null){
                destinationBoneTransforms[i] = bone.localTransform;
            }else{
                destinationBoneTransforms[i] = bone.localTransform * destinationBoneTransforms[bone.parent.index];
            }
        }
    }
}
