package src.content.contentreaders;
import src.graphics.*;
import src.graphics.vertices.VertexPositionNormalTexture;
import src.parser.*;
import src.scene.Scene;
import src.math.*;

using Lambda;

class ModelReader{
    var gd : GraphicsDevice;
    public function new(gd : GraphicsDevice){
        this.gd = gd;
    }

    public function makeModelFromMqo(mqo : Mqo) : Model{
        // 基本1オブジェクトに対して1Mesh1MeshPart
        // faceを見て複数マテリアルがあったらMeshPartを増やす
        // 頂点及びマテリアルが被っていてUVが異なる物があったら頂点分ける
        // そのとき頂点Indexがかぶらないように後ろに追加していき、
        // 比較しやすいようにする
        // MeshPartができたらインデックスを順番にconcatすればOK
        var meshes = new Array<Mesh>();
        for(obj in mqo.objects){
            meshes.push(makeMeshFromMqoObject(obj, mqo));
        }
        return new Model(gd, meshes, null);
    }

    public function makeModelFromX(x : X) : Model{
        var meshes : Array<Mesh> = makeMeshesFromXFrame(x.root);
        var rootBone = makeBoneTreeFromXFrame(x.root, null);
        var bones = makeBonesFromBoneTree(rootBone);
        return new Model(gd, meshes, bones);
    }

    function makeMeshesFromXFrame(frame : XFrame) : Array<Mesh>{
        var meshes = new Array<Mesh>();
        if(frame.mesh != null)meshes.push(makeMeshFromXMesh(frame.mesh, frame.name));
        for(f in frame.frames){
            meshes = meshes.concat(makeMeshesFromXFrame(f));
        }
        return meshes;
    }


    function makeBoneTreeFromXFrame(frame : XFrame, parent : Bone) : Bone{
        var children = new Array<Bone>();
        var bone = new Bone(frame.name, children, frame.mat, Mat4.identity, parent, 0);
        for(f in frame.frames){
            children.push(makeBoneTreeFromXFrame(f, bone));
        }
        return bone;
    }

    function makeBonesFromBoneTree(root : Bone) : Array<Bone>{
        var index = 0;
        var bones = new Array<Bone>();
        var boneQueue = new List<Bone>();
        boneQueue.push(root);
        // 幅優先
        while(boneQueue.length > 0){
            var selectedBone = boneQueue.pop();
            selectedBone.index = index;
            bones.push(selectedBone);
            index++;

            // 子を詰める
            for(bone in selectedBone.children){
                boneQueue.push(bone);
            }
        }
            return bones;
    }

    function makeMeshFromXMesh(xMesh : XMesh, name : String) : Mesh{
        // 今回頂点を増やさないで良い
        // Materialが複数ある場合はパーツを分ける
        var vertices = new Array<VertexPositionNormalTexture>();
        var mesh : Mesh;
        var partIndices = new Map<Int, Array<Int>>();

        var materials = xMesh.meshMaterialList;
        for(faceIndex in 0...xMesh.faces.length){
            var face = xMesh.faces[faceIndex];
            // 法線計算
            var normal = (xMesh.vertices[face[1]] - xMesh.vertices[face[0]]).cross(
                    xMesh.vertices[face[2]] - xMesh.vertices[face[0]]).normalize();
            // まだ見ぬマテリアルを使った場合配列を作る
            if(!partIndices.exists(materials.faceIndices[faceIndex])){
                partIndices.set(materials.faceIndices[faceIndex], new Array<Int>());
            }
            for(i in 0...3){
                if(vertices[face[i]] == null){
                    vertices[face[i]] = (new VertexPositionNormalTexture(
                                xMesh.vertices[face[i]],
                                normal,
                                xMesh.meshTextureCoords[face[i]]));
                    partIndices.get(materials.faceIndices[faceIndex]).push(face[i]);
                }else{
                    vertices[face[i]].normal += normal;
                } 
            }
        }
        var indices = new Array<Int>();
        var meshParts = new Array<MeshPart>();
        var offset = 0;
        for(key in partIndices.keys()){
            indices = indices.concat(partIndices.get(key));
            meshParts.push(new MeshPart(gd, makeMaterialFromXMaterial(materials.materials[key]), partIndices.get(key).length, offset * 2/*short型なので2バイト*/, null));
            offset += partIndices.get(key).length;
        }
        mesh = new Mesh(gd, name, vertices.flatten().flatten().array(), indices);
        for(part in meshParts){
            part.setParent(mesh);
        }
        return mesh;
    }

    function makeMaterialFromXMaterial(xMat : XMaterial) : Material{
        return new Material(gd, xMat.name, gd.shaderProgramCache.getProgram("classic", "classic"),
                xMat.color, 0, 0, 0, 0, xMat.tex);
    }

    function makeMeshFromMqoObject(object : MqoObject, mqo : Mqo) : Mesh{
        var vertices = new Array<VertexPositionNormalTexture>();
        var mesh : Mesh;
        // Material番号をキーとする頂点インデックス
        var partIndices = new Map<Int, Array<Int>>();
        // 被りがあるかindexMapで検証
        // UnionTree的なものになる
        // indexを渡すと同一座標でUVの異なる頂点を返す
        // マテリアルが同じだろうが異なっていようが
        // UVが異なっていたら頂点を追加する
        var indexMap = new Map<Int, Array<Int>>();
        for(face in object.faces){
            // 法線の計算
            var normal = (object.vertices[face.indices[1]] - object.vertices[face.indices[0]]).cross(
                    object.vertices[face.indices[2]] - object.vertices[face.indices[0]]).normalize();
            // まだ見ぬマテリアルがあった場合配列を作っておく
            if(!partIndices.exists(face.material)){
                partIndices.set(face.material, new Array<Int>());
            }
            for(i in 0...3){
                if(!indexMap.exists(face.indices[i])){
                    // 初めてみた頂点
                    indexMap.set(face.indices[i], new Array<Int>());
                    vertices[face.indices[i]] = (new VertexPositionNormalTexture(
                                object.vertices[face.indices[i]],
                                normal,
                                face.uv[i]));
                    partIndices.get(face.material).push(face.indices[i]);
                }else{
                    // もう見た頂点
                    var foundIndex = false;
                    for(index in [face.indices[i]].concat(indexMap.get(face.indices[i]))){
                        // なんだろうと頂点を共有していたら法線を再計算する
                        vertices[index].normal += normal;
                        if(vertices[index].textureCoordinate == face.uv[i]){
                            // 頂点を新たに追加する必要なし
                            partIndices.get(face.material).push(index);
                            foundIndex = true;
                        }
                    }
                    if(!foundIndex){
                        // 頂点を新たに追加する必要がある
                        object.vertices.push(object.vertices[face.indices[i]]);
                        var newIndex = object.vertices.length - 1;
                        indexMap.get(face.indices[i]).push(newIndex);
                        vertices[newIndex] = (new VertexPositionNormalTexture(
                                    object.vertices[newIndex],
                                    vertices[face.indices[i]].normal,
                                    face.uv[i]));
                        partIndices.get(face.material).push(newIndex);
                    }
                }
            }
        }
        var indices = new Array<Int>();
        var meshParts = new Array<MeshPart>();
        var offset = 0;
        for(key in partIndices.keys()){
            indices = indices.concat(partIndices.get(key));
            meshParts.push(new MeshPart(gd, mqo.materials[key], partIndices.get(key).length, offset * 2/*short型なので2バイト*/, null));
            offset += partIndices.get(key).length;
        }
        mesh = new Mesh(gd, object.name, vertices.flatten().flatten().array(), indices);
        for(part in meshParts){
            part.setParent(mesh);
        }
        return mesh;
    }
}
