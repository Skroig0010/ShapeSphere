package src.math;

class Matrix4x4{
    public var m : Array<Float>;

    public function new(?m : Array<Float>){
        if(m != null){
            // 4x4で無かった場合エラーを出すべきか
            if(m.length != 16){
                js.Browser.alert("4x4行列ではないが");
            }
            this.m = m;
        }else{
            this.m = [0, 0, 0, 0, 
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0];
        }
    }

}

/*@:forward
abstract AMatrix4x4(Matrix4x4) from Matrix4x4 to Matrix4x4{
    @:commutative 
    @:op(A+B)
    public inline function add(m2 : AMatrix4x4) : AMatrix4x4{
        var m3 : AMatrix4x4 = new Matrix4x4();
        for(i in 0...15){
            m3.m[i] = m[i] + m2.m[i];
        }
        return cast(m3, AMatrix4x4);
    }
    // commutativeではない
    @:op(A*B) 
    public inline function mult(m2 : AMatrix4x4) : AMatrix4x4{
        return null;
    }
}*/
