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
        var vert = js.Browser.window.fetch("main.vert").then(function (response){
            return response.text();
        });
        var frag = js.Browser.window.fetch("main.frag").then(function (response){
            return response.text();
        });
        var mqo = js.Browser.window.fetch("uc2.mqo").then(function (response){
            return response.text();
        });

        js.Promise.all([vert, frag, mqo]).then(function (response){
            var vert = cast (response[0], String);
            var frag = cast (response[1], String);
            var mqo = cast (response[2], String);

            var parser = new src.parser.MqoParser(mqo, gd);
            var x = parser.getMqo();
            var a = new src.content.contentreaders.ModelReader(gd);
            meshes = a.makeMeshesFromMqo(x);

            scene = x.scene;
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
            m.render();
        }
        gd.endRender();
    }
}
