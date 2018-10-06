package shapesphere.input;
import js.html.KeyboardEvent;

class Keyboard implements IKeyboard{
    static var dummy = new Keyboard();
    static var state : Map<Int, Bool>;

    // dummyしか呼ばないコンストラクタ
    function new(){
        if(dummy == null){
            dummy = this;
            js.Browser.document.onkeydown = onKeyDown;
            js.Browser.document.onkeyup = onKeyUp;
            state = new Map<Int, Bool>();
        }
    }
    
    // 押されてたらtrue
    public function getKey(key : Keys) : Bool{
        return if (state.exists(key)){
            state.get(key);
        }else{
            false;
        }
    }

    // 以下イベントハンドラ
    static function onKeyDown(e : KeyboardEvent){
        state.set(e.keyCode, true);
    }
    static function onKeyUp(e : KeyboardEvent){
        state.set(e.keyCode, false);
    }

    public static function resetKeys(){
        state = new Map<Int, Bool>();
    }
}
