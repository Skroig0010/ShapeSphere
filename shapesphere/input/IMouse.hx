package shapesphere.input;
import shapesphere.math.Vec2;

interface IMouse{
    public function getButton(button : MouseButton) : Bool;
    public function getPosition() : Vec2;
}
