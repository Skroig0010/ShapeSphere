package shapesphere.input;

class InputManager{
    static var dummy = new InputManager();

    // ウィンドウからはみ出たときの処理
    function new(){
        if(dummy == null){
            dummy = this;
            js.Browser.window.onblur = resetInput;
        }
    }

    public static function resetInput(){
        Keyboard.resetKeys();
        Mouse.resetButtons();
    }

}
