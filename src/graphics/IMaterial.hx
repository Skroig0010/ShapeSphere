package src.graphics;
import js.html.webgl.RenderingContext;
import js.html.webgl.UniformLocation;
import src.graphics.shader.Shader;
import src.math.*;
using src.graphics.GraphicsExtensions;

interface IMaterial{
    public var shader(default, null):Shader;
    public function apply(world : Mat4, view : Mat4, projection : Mat4):Void;
}

