package shapesphere.input;
import js.html.MouseEvent;
import shapesphere.math.Vec2;

class Mouse implements IMouse{
    static var dummy = new Mouse();
    static var state : Map<Int, Bool>;
    static var position : Vec2;

    // dummyしか呼ばないコンストラクタ
    function new(){
        if(dummy == null){
            dummy = this;
            js.Browser.document.onmousedown = onMouseDown;
            js.Browser.document.onmouseup = onMouseUp;
            // js.Browser.document.onclick = onClick;
            // js.Browser.document.ondblclick = onDoubleClick;
            js.Browser.document.onmousemove = onMouseMove;
            state = new Map<Int, Bool>();
        }
    }
    
    public function getButton(key : MouseButton) : Bool{
        return if (state.exists(key)){
            state.get(key);
        }else{
            false;
        }
    }

    public function getPosition() : Vec2{
        return position;
    }

    // 以下イベントハンドラ
    static function onMouseDown(e : MouseEvent){
        state.set(e.button, true);
    }
    static function onMouseUp(e : MouseEvent){
        state.set(e.button, false);
    }
    static function onMouseMove(e : MouseEvent){
        position = new Vec2(e.clientX, e.clientY);
    }

    public static function resetButtons(){
        state = new Map<Int, Bool>();
    }
}
