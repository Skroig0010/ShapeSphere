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

    static var model : Model;
    static var model2 : Model;
    static var scene : Scene;

    static var screen = {width : 800, height : 600};

    static public function main(){
        init();
        var mqofile = js.Browser.window.fetch("Body.mqo").then(function (response){
            return response.text();
        });

        var xfile = js.Browser.window.fetch("body.x").then(function (response){
            return response.text();
        });

        js.Promise.all([mqofile, xfile]).then(function (response){
            var mqofile = cast (response[0], String);
            var xfile = cast (response[1], String);

            var reader = new src.content.contentreaders.ModelReader(gd);

            var mparser = new src.parser.mqo.Parser(mqofile, gd);
            var mqo = mparser.getMqo();
            model = reader.makeModelFromMqo(mqo);

            var xparser = new src.parser.x.Parser(xfile);
            var x = xparser.getX();
            model2 = reader.makeModelFromX(x);

            // scene = mqo.scene;
            scene = new Scene();
            var position  = new Vec3(0, 450, 410);
            var eye = position;
            scene.setCamera(eye, new Vec3(0, 0, 0), new Vec3(0, 1, 0));

            js.Browser.window.requestAnimationFrame(loop);
        });
    }

    static function init(){
        var canvas = createCanvas(screen.width, screen.height);
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
        gd.debugPrimitive.setPrimitive(Point(new Vec3(200, 0, 0), 10), Red, false);
        gd.debugPrimitive.setPrimitive(Point(new Vec3(0, 200, 0), 10), Green, false);
        gd.debugPrimitive.setPrimitive(Point(new Vec3(0, 0, 200), 10), Blue, false);
        gd.debugPrimitive.setPrimitive(Line(new Vec3(0, 0, 0), new Vec3(200, 0, 0)), Red, false);
        gd.debugPrimitive.setPrimitive(Line(new Vec3(0, 0, 0), new Vec3(0, 200, 0)), Green, false);
        gd.debugPrimitive.setPrimitive(Line(new Vec3(0, 0, 0), new Vec3(0, 0, 200)), Blue, false);
        gd.debugPrimitive.setPrimitive(AABB(new Vec3(150, 350, 50), new Vec3(-150, 0, -50)), White, false);
    }

    static function update(dt : Float){
        var c = Math.cos(0.01);
        var s = Math.sin(0.01);
        var eye = scene.camera.position;
        eye.x = eye.x * c - eye.z * s;
        eye.z = eye.x * s + eye.z * c;
    }

    static function render(dt : Float){
        gd.startRender();
        model.render(Mat4.translate(new Vec3(35, 0, 0)) * Mat4.scale(new Vec3(2, 2, 2)), Mat4.lookAt(scene.camera), Mat4.perspective(1280/960, Math.PI / 2, 10, 1000000));
        model2.render(Mat4.rotateX(3.141592653589793238 / 2) * Mat4.scale(new Vec3(236, 236, 236)), Mat4.lookAt(scene.camera), Mat4.perspective(screen.width / screen.height, Math.PI / 2, 10, 100000));
        gd.debugPrimitive.drawPrimitives(Mat4.lookAt(scene.camera), Mat4.perspective(screen.width / screen.height, Math.PI / 2, 10, 100000));
        gd.endRender();
    }
}
