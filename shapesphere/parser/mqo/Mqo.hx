package shapesphere.parser.mqo;
import shapesphere.scene.Scene;
import shapesphere.graphics.Mesh;
import shapesphere.graphics.MeshPart;
import shapesphere.graphics.materials.IMaterial;

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
