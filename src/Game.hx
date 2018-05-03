package src;
import src.graphics.*;
import src.graphics.states.*;
import src.graphics.shader.*;
import src.graphics.vertices.*;
import src.math.*;
import src.scene.Scene;

using Lambda;

class Game{
    static public var gd : GraphicsDevice;
    // requestAnimationFrameの引数前回値
    static var prevTime : Float;

    static var mesh : Mesh;
    static var mesh2 : Mesh;
    static var scene : Scene;

    static public function main(){
        init();
        var vert = js.Browser.window.fetch("main.vert").then(function (response){
            return response.text();
        });
        var frag = js.Browser.window.fetch("main.frag").then(function (response){
            return response.text();
        });
        var mqo = js.Browser.window.fetch("sample.mqo").then(function (response){
            return response.text();
        });
        var tex = new js.Promise(function(resolve, reject){
            new Texture("sample.png", resolve); 
        });

        js.Promise.all([vert, frag, tex]).then(function (response){
            var vert = cast (response[0], String);
            var frag = cast (response[1], String);
            var tex = cast (response[2], Texture);

            var shader = new Shader(vert, frag);

            scene = new Scene();
            var eye = new Vec3(0, 0.4, 1);
            scene.setCamera(eye, eye.normalize(), new Vec3(0, 1, 0));

            tex.setFilter(TextureFilter.Point);
            var mat = new Material(gd, shader, Color.Red, 0.0, 0.0, 0.0, tex);

            var vertices : Array<Float> = [
                new VertexPositionNormalTexture(new Vec3(0.0, 0.5, 0.0), new Vec3(0.0, 0.0, 0.0), new Vec2(0.0, 0.0)), 
                new VertexPositionNormalTexture(new Vec3(0.5, 0.0, 0.5), new Vec3(0.0, 0.0, 0.0), new Vec2(1.0, 0.0)), 
                new VertexPositionNormalTexture(new Vec3(-0.5, 0.0, -0.5), new Vec3(0.0, 0.0, 0.0), new Vec2(0.0, 1.0)),].flatten().flatten().array();

            mesh = new Mesh(gd, scene, vertices, [0,1,2]);
            var meshpart = new MeshPart(gd, mat, 3, 0, mesh);
            mesh.meshParts.add(meshpart);

            var vertices2:Array<Float> = [
                new VertexPositionNormalTexture(new Vec3(0.0, 0.5, 0.0), new Vec3(0.0, 0.0, 0.0), new Vec2(0.0, 0.0)), 
                new VertexPositionNormalTexture(new Vec3(0.5, 0.0, -0.5), new Vec3(0.0, 0.0, 0.0), new Vec2(0.0, 1.0)), 
                new VertexPositionNormalTexture(new Vec3(-0.5, 0.0, 0.5), new Vec3(0.0, 0.0, 0.0), new Vec2(1.0, 1.0)),].flatten().flatten().array();

            mesh2 = new Mesh(gd, scene, vertices2, [0,1,2]);
            var meshpart2 = new MeshPart(gd, mat, 3, 0, mesh2);
            mesh2.meshParts.add(meshpart2);

            js.Browser.window.requestAnimationFrame(loop);
        });
    }

    static function init(){
        var canvas = createCanvas(640, 480);
        gd = new GraphicsDevice(canvas);
    }

    // canvasの作成
    static function createCanvas(width:Int, height:Int){
        var canvas = cast(js.Browser.document.createElement("canvas"), js.html.CanvasElement);
        canvas.width = width;
        canvas.height = height;
        js.Browser.document.body.appendChild(canvas);
        return canvas;
    }

    static function loop(time:Float){
        js.Browser.window.requestAnimationFrame(loop);
        var dt = time - prevTime;
        prevTime = time;
        update(dt);
        render(dt);
    }

    static function update(dt : Float){
        var c = Math.cos(0.01);
        var s = Math.sin(0.01);
        var eye = scene.camera.position;
        eye.x = eye.x * c - eye.z * s;
        eye.z = eye.x * s + eye.z * c;
        scene.camera.forward = eye.normalize();
    }

    static function render(dt : Float){
        gd.startRender();
        mesh.render();
        mesh2.render();
        gd.endRender();
    }
}
