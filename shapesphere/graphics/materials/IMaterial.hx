package shapesphere.graphics.materials;
import js.html.webgl.RenderingContext;
import js.html.webgl.UniformLocation;
import shapesphere.graphics.shader.Shader;
import shapesphere.math.*;
using shapesphere.graphics.GraphicsExtensions;

interface IMaterial{
    public var shader(default, null):Shader;
    public function apply(world : Mat4, view : Mat4, projection : Mat4):Void;
}
