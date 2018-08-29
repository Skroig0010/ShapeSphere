package shapesphere;
import shapesphere.graphics.*;
import shapesphere.graphics.states.*;
import shapesphere.graphics.shader.*;
import shapesphere.graphics.vertices.*;
import shapesphere.math.*;
import shapesphere.scene.Scene;

using Lambda;

class Game{
    static public var gd : GraphicsDevice;
    // requestAnimationFrameの引数前回値
    static var prevTime : Float = 0.0;

    static var model : Model;
    static var model2 : Model;
    static var scene : Scene;

    static var screen = {width : 800, height : 600};

    static public function main(){
        init();
        var mqofile = js.Browser.window.fetch("Body.mqo").then(function (response){
            return response.text();
        });

        var xfile = js.Browser.window.fetch("test2.x").then(function (response){
            return response.text();
        });

        js.Promise.all([mqofile, xfile]).then(function (response){
            var mqofile = cast (response[0], String);
            var xfile = cast (response[1], String);

            var reader = new shapesphere.content.contentreaders.ModelReader(gd);

            var mparser = new shapesphere.parser.mqo.Parser(mqofile, gd);
            var mqo = mparser.getMqo();
            model = reader.makeModelFromMqo(mqo);

            var xparser = new shapesphere.parser.x.Parser(xfile);
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
        gd.debugPrimitive.setPrimitive(Line(new Vec3(0, 0, 0), new Vec3(100.0, -100.0, 0.0)), White, false);
        gd.debugPrimitive.setPrimitive(Line(new Vec3(0, 0, 0), new Vec3(-100.0, 100.0, 0.0)), White, false);
        gd.debugPrimitive.setPrimitive(Line(new Vec3(0, 0, 0), new Vec3(-100.0, -100.0, 0.0)), White, false);
        gd.debugPrimitive.setPrimitive(Line(new Vec3(0, 0, 0), new Vec3(100.0, 100.0, 0.0)), White, false);
    }

    static private var timer : Float = 0.0;

    static function update(dt : Float){
        timer += dt;
        var eye = scene.camera.position;
        eye.x = 410 * Math.cos(timer / 500);
        eye.z = 410 * Math.sin(timer / 500);
    }

    static function render(dt : Float){
        gd.startRender();
        model2.render(Mat4.rotateX(timer / 200) * Mat4.scale(new Vec3(100, 100, 100)), Mat4.lookAt(scene.camera), Mat4.perspective(screen.width / screen.height, Math.PI / 2, 10, 100000));
        model.render(Mat4.translate(new Vec3(35, 0, 0)) * Mat4.scale(new Vec3(2, 2, 2)), Mat4.lookAt(scene.camera), Mat4.perspective(1280/960, Math.PI / 2, 10, 1000000));
        gd.debugPrimitive.drawPrimitives(Mat4.lookAt(scene.camera), Mat4.perspective(screen.width / screen.height, Math.PI / 2, 10, 100000));
        gd.endRender();
    }
}
