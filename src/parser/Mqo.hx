package src.parser;
import src.scene.Scene;
import src.graphics.Mesh;
import src.graphics.MeshPart;
import src.graphics.Material;

class Mqo{
    public var scene : Scene;
    public var mesh : Mesh;
    public var meshParts : Array<MeshPart>;
    public var materials : Array<Material>;

    public function new(scene, mesh, meshParts, materials){
        this.scene = scene;
        this.mesh = mesh;
        this.meshParts = meshParts;
        this.materials = materials;
    }
}
