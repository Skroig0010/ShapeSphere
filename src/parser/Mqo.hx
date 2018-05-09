package src.parser;
import src.scene.Scene;
import src.graphics.Mesh;
import src.graphics.MeshPart;
import src.graphics.Material;

class Mqo{
    public var scene : Scene;
    public var materials : Array<Material>;
    public var objects : Array<MqoObject>;

    public function new(scene : Scene, materials : Array<Material>, objects : Array<MqoObject>){
        this.scene = scene;
        this.materials = materials;
        this.objects = objects;
    }
}
