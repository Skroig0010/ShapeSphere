package src.parser.mqo;
import src.scene.Scene;
import src.graphics.Mesh;
import src.graphics.MeshPart;
import src.graphics.IMaterial;

class Mqo{
    public var scene : Scene;
    public var materials : Array<IMaterial>;
    public var objects : Array<Object>;

    public function new(scene : Scene, materials : Array<IMaterial>, objects : Array<Object>){
        this.scene = scene;
        this.materials = materials;
        this.objects = objects;
    }
}
