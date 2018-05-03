package src.math;
import src.camera.Camera;

class Mat4Data{
    public var m : Array<Float>;

    public function new(?m : Array<Float>){
        this.m = switch(m){
            case null: [
                0, 0, 0, 0, 
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0];
            default: m;
        };
    }

    public inline function iterator(){
        return m.iterator();
    }
}
