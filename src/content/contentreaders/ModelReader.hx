package src.content.contentreaders;
import src.graphics.*;
import src.graphics.materials.*;
import src.graphics.vertices.VertexPositionNormalTexture;
import src.graphics.vertices.VertexPositionNormalTextureWeights;
import src.parser.mqo.*;
import src.parser.x.*;
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
        var meshes = new Array<src.graphics.Mesh>();
        for(obj in mqo.objects){
            meshes.push(makeMeshFromMqoObject(obj, mqo));
        }
        return new Model(gd, meshes, null);
    }

    public function makeModelFromX(x : X) : Model{
        var rootBone = makeBoneTreeFromXFrame(x.root, null);
        // ModelにはBoneの配列が必要なのでこれも作る
        var bones = makeBonesFromBoneTree(rootBone);
        // xMeshの配列があると楽なので用意しておく
        var xMeshes = makeXMeshes(x.root);
        var meshes : Array<src.graphics.Mesh> = makeMeshesFromXMeshes(xMeshes, bones);
        return new Model(gd, meshes, bones);
    }

    function makeMeshesFromXMeshes(xMeshes : Array<src.parser.x.Mesh>, bones : Array<Bone>) : Array<src.graphics.Mesh>{
        var meshes = new Array<src.graphics.Mesh>();

        // xMesh.skinWeightsから逆引き辞書を作る
        var skinWeightVertices = new Array<{indices : Array<Float>, weights : Array<Float>}>(); 
        // SkinWeightに対応する頂点があったら対応する構造体に追加
        var hasSkin = true;
        for(m in xMeshes){
            var skin = m.skinWeights;
            if(skin == null){
                hasSkin = false;
                break;
            }

            // このskinWeightsに対応するBoneのindexの取得
            var boneIndex = -1;

            for(i in 0...bones.length){
                if(bones[i].name == skin.transformNodeName){
                    boneIndex = i;
                    break;
                }
            }

            for(i in 0...skin.nWeights){
                if(skinWeightVertices[skin.vertexIndices[i]] == null)skinWeightVertices[skin.vertexIndices[i]] = {indices : new Array<Float>(), weights : new Array<Float>()};
                skinWeightVertices[skin.vertexIndices[i]].indices.push(boneIndex);
                skinWeightVertices[skin.vertexIndices[i]].weights.push(skin.weights[i]);
            }
        }
        // スキンウェイトがあったらウェイト付きメッシュ、そうでなかったらウェイトなしメッシュを作成
        if(hasSkin){
            // meshの作成
            for(xMesh in xMeshes){
                meshes.push(makeMeshFromXMeshWithSkinWeight(xMesh, skinWeightVertices, bones));
            }
        }else{

            // meshの作成
            for(xMesh in xMeshes){
                meshes.push(makeMeshFromXMesh(xMesh));
            }
        }

        return meshes;
    }

    function makeXMeshes(frame : Frame) : Array<src.parser.x.Mesh>{
        var xMeshes = new Array<src.parser.x.Mesh>();
        if(frame.mesh != null)xMeshes.push(frame.mesh);
        for(f in frame.frames){
            xMeshes = xMeshes.concat(makeXMeshes(f));
        }
        return xMeshes;
    }


    function makeBoneTreeFromXFrame(frame : Frame, parent : Bone) : Bone{
        var children = new Array<Bone>();
        // indexだけ決定できないのでmakeBonesFromBoneTreeで作成
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
                boneQueue.add(bone);
            }
        }
        return bones;
    }

    function makeMeshFromXMesh(xMesh : src.parser.x.Mesh) : src.graphics.Mesh{
        // 今回頂点を増やさないで良い
        // Materialが複数ある場合はパーツを分ける
        var vertices = new Array<VertexPositionNormalTexture>();
        var mesh : src.graphics.Mesh;
        var partIndices = new Map<Int, Array<Int>>();

        var materials = xMesh.meshMaterialList;
        for(faceIndex in 0...xMesh.faces.length){
            var face = xMesh.faces[faceIndex];

            // まだ見ぬマテリアルを使った場合配列を作る
            if(!partIndices.exists(materials.faceIndices[faceIndex])){
                partIndices.set(materials.faceIndices[faceIndex], new Array<Int>());
            }
            for(i in 0...3){
                vertices[face[i]] = (new VertexPositionNormalTexture(
                            xMesh.vertices[face[i]],
                            // 以下は、メタセコで作ったモデルはface[i]に、直接Blenderで作ったモデルはfaceIndexにする
                            xMesh.meshNormals.normals[if(xMesh.faces.length == xMesh.meshNormals.normals.length) faceIndex else face[i]],
                            xMesh.meshTextureCoords[face[i]]));
                partIndices.get(materials.faceIndices[faceIndex]).push(face[i]);
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
        mesh = new src.graphics.Mesh(gd, xMesh.name, vertices.flatten().flatten().array(), indices, VertexPositionNormalTexture.vertexDeclaration);

        for(part in meshParts){
            part.setParent(mesh);
        }
        return mesh;
    }

    function makeMeshFromXMeshWithSkinWeight(xMesh : src.parser.x.Mesh,skinWeightVertices : Array<{indices : Array<Float>, weights : Array<Float>}>,  bones : Array<Bone>) : src.graphics.Mesh{
        // 今回頂点を増やさないで良い
        // Materialが複数ある場合はパーツを分ける
        var vertices = new Array<VertexPositionNormalTextureWeights>();
        var mesh : src.graphics.Mesh;
        var partIndices = new Map<Int, Array<Int>>();

        var materials = xMesh.meshMaterialList;
        for(faceIndex in 0...xMesh.faces.length){
            var face = xMesh.faces[faceIndex];

            // まだ見ぬマテリアルを使った場合配列を作る
            if(!partIndices.exists(materials.faceIndices[faceIndex])){
                partIndices.set(materials.faceIndices[faceIndex], new Array<Int>());
            }
            for(i in 0...3){
                var skin = skinWeightVertices[face[i]];
                if(skin.indices.length < 4){
                    // 足りない分0を入れて補う
                    for(i in 0...4 - skin.indices.length){
                        skin.indices.push(0);
                        skin.weights.push(0);
                    }
                }
                var indices = skin.indices;
                var weights = skin.weights;
                vertices[face[i]] = (new VertexPositionNormalTextureWeights(
                            xMesh.vertices[face[i]],
                            // TODO:以下は、メタセコで作ったモデルはface[i]に、直接Blenderで作ったモデルはfaceIndexにする
                            xMesh.meshNormals.normals[if(xMesh.faces.length == xMesh.meshNormals.normals.length) faceIndex else face[i]],
                            xMesh.meshTextureCoords[face[i]],
                            indices,
                            weights));
                partIndices.get(materials.faceIndices[faceIndex]).push(face[i]);
            }
        }
        var indices = new Array<Int>();
        var meshParts = new Array<MeshPart>();
        var offset = 0;
        for(key in partIndices.keys()){
            indices = indices.concat(partIndices.get(key));
            meshParts.push(new MeshPart(gd, makeSkinnedMaterialFromXMaterial(materials.materials[key], bones), partIndices.get(key).length, offset * 2/*short型なので2バイト*/, null));
            offset += partIndices.get(key).length;
        }
        mesh = new src.graphics.Mesh(gd, xMesh.name, vertices.flatten().flatten().array(), indices, VertexPositionNormalTextureWeights.vertexDeclaration);
        // parentBoneの設定
        for(bone in bones){
            if(mesh.name == bone.name){
                mesh.parentBone = bone;
                break;
            }
        }

        for(part in meshParts){
            part.setParent(mesh);
        }
        return mesh;
    }

    function makeSkinnedMaterialFromXMaterial(xMat : Material, bones:Array<Bone>) : IMaterial{
        return new src.graphics.materials.SkinnedMaterial(gd, xMat.name, gd.shaderProgramCache.getProgram("skinned", "skinned"),
                xMat.color, xMat.power, xMat.spc, xMat.emi, xMat.tex, bones);
    }

    function makeMaterialFromXMaterial(xMat : Material) : IMaterial{
        return new src.graphics.materials.XMaterial(gd, xMat.name, gd.shaderProgramCache.getProgram("classic", "classic"),
                xMat.color, xMat.power, xMat.spc, xMat.emi, xMat.tex);
    }

    function makeMeshFromMqoObject(object : Object, mqo : Mqo) : src.graphics.Mesh{
        var vertices = new Array<VertexPositionNormalTexture>();
        var mesh : src.graphics.Mesh;
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
            for(i in [0, 2, 1]){
                if(!indexMap.exists(face.indices[i])){
                    // 初めて見た頂点
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
        mesh = new src.graphics.Mesh(gd, object.name, vertices.flatten().flatten().array(), indices, VertexPositionNormalTexture.vertexDeclaration);
        for(part in meshParts){
            part.setParent(mesh);
        }
        return mesh;
    }
}
