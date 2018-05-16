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
    static var meshes : Array<Mesh>;
    static var scene : Scene;

    static public function main(){
        init();
        var mqofile = js.Browser.window.fetch("uc2.mqo").then(function (response){
            return response.text();
        });

        var xfile = js.Browser.window.fetch("test_meshonly.x").then(function (response){
            return response.text();
        });

        js.Promise.all([mqofile, xfile]).then(function (response){
            var mqofile = cast (response[0], String);
            var xfile = cast (response[1], String);

            // var mparser = new src.parser.MqoParser(mqofile, gd);
            // var mqo = mparser.getMqo();
            // var reader = new src.content.contentreaders.ModelReader(gd);
            // meshes = reader.makeMeshesFromMqo(mqo);

            var xparser = new src.parser.XParser(xfile);
            var x = xparser.getX();

            // scene = mqo.scene;
            var eye = scene.camera.position + new Vec3(0, 400, 400);
            scene.setCamera(eye, (eye - new Vec3(0, 400, 0)).normalize(), new Vec3(0, 1, 0));

            js.Browser.window.requestAnimationFrame(loop);
        });
    }

    static function init(){
        var canvas = createCanvas(1280, 960);
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
        scene.camera.forward = (eye - new Vec3(0, 400, 0)).normalize();
    }

    static function render(dt : Float){
        gd.startRender();
        for(m in meshes){
            m.render(Mat4.scale(new Vec3(6,6,6)), Mat4.lookAt(scene.camera), Mat4.perspective(1280/960, Math.PI / 2, 100, 10000));
        }
        gd.endRender();
    }
}
