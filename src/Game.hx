package src;
import src.graphics.*;
import src.math.*;

class Game{
    static public var gd : GraphicsDevice;
    // requestAnimationFrameの引数前回値
    static var prevTime : Float;

    static var mesh : Mesh;
    static var mesh2 : Mesh;

    static public function main(){
        init();
        var vert = js.Browser.window.fetch("main.vert").then(function (response){
            return response.text();
        });
        var frag = js.Browser.window.fetch("main.frag").then(function (response){
            return response.text();
        });
        js.Promise.all([vert, frag]).then(function (response){
            var vert = cast (response[0], String);
            var frag = cast (response[1], String);

            var shader = gd.createShaderProgram(vert, frag);

            var mat = new Material(gd, shader, Color.Red, 0.0, 0.0, 0.0, null);
            var vertices:Array<Float> = [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0,
        -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0];

            mesh = new Mesh(gd, 0, vertices, [0,1,2]);
            var meshpart = new MeshPart(gd, mat, 3, 0, mesh);
            mesh.meshParts.add(meshpart);

            var vertices2:Array<Float> = [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0,
            -1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0];

            mesh2 = new Mesh(gd, 0, vertices2, [0,1,2]);
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
        var dt = time - prevTime;
        prevTime = time;
        update(dt);
        render(dt);
        js.Browser.window.requestAnimationFrame(loop);
    }

    static function update(dt : Float){
    }

    static function render(dt : Float){
        gd.startRender();
        mesh.render();
        mesh2.render();
        gd.endRender();
    }
}
