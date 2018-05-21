package src.graphics;
import js.html.webgl.RenderingContext;
import js.html.webgl.UniformLocation;
import js.html.webgl.Buffer;
import src.math.*;
import src.graphics.Color;
import src.graphics.shader.Shader;
import src.graphics.vertices.VertexPositionColor;
using Lambda;
using src.graphics.GraphicsExtensions;

typedef Primitive = {
    var shape : DebugPrimitiveShape;
    var color : Color;
}

// デバッグ用プリミティブ描画クラス
class DebugPrimitive{
    var gd : GraphicsDevice;

    var primitives = new Array<Primitive>();
    var skeltonPrimitives = new Array<Primitive>();

    var vertexBufferPoint : Buffer;
    var vertexBufferLine : Buffer;
    var indexBufferLine : Buffer;

    var lineShader : Shader;
    var pointShader : Shader;

    var lineViewMatrixLocation : UniformLocation;
    var lineProjMatrixLocation : UniformLocation;

    var pointViewMatrixLocation : UniformLocation;
    var pointProjMatrixLocation : UniformLocation;
    var pointSizeLocation : UniformLocation;

    public function new(gd : GraphicsDevice){
        this.gd = gd;
        lineShader = gd.shaderProgramCache.getProgram("debugprimitive", "debugprimitive");
        pointShader = gd.shaderProgramCache.getProgram("debugpoint", "debugprimitive");
        vertexBufferPoint = gd.createDynamicBuffer();
        vertexBufferLine = gd.createDynamicBuffer();
        indexBufferLine = gd.createDynamicBuffer();
        lineViewMatrixLocation = lineShader.getUniformLocation("viewMatrix");
        lineProjMatrixLocation = lineShader.getUniformLocation("projMatrix"); 
        pointViewMatrixLocation = pointShader.getUniformLocation("viewMatrix");
        pointProjMatrixLocation = pointShader.getUniformLocation("projMatrix"); 
        pointSizeLocation = pointShader.getUniformLocation("pointSize");
    }

    public function setPrimitive(shape : DebugPrimitiveShape, color :  Color, skelton : Bool){
        (if(skelton) skeltonPrimitives else primitives).push({shape : shape, color : color});
    }

    public function drawPrimitives(view : Mat4, projection : Mat4){
        // 登録されたプリミティブをリストに登録
        var pointLists = new Map<Int, Array<VertexPositionColor>>();
        var lineList = new Array<VertexPositionColor>();
        var indexList = new Array<Int>();
        var count = 0;
        for(primitive in primitives){
            switch(primitive.shape){
                case Point(v, size) : 
                    if(!pointLists.exists(size)){
                        pointLists.set(size, new Array<VertexPositionColor>());
                    }
                    pointLists.get(size).push(new VertexPositionColor(v, primitive.color.toVec4()));
                case Line(v1, v2) :
                    lineList.push(new VertexPositionColor(v1, primitive.color.toVec4()));
                    lineList.push(new VertexPositionColor(v2, primitive.color.toVec4()));
                    indexList.push(count);
                    indexList.push(count + 1);
                    count += 2;
                case Triangle(v1, v2, v3) :
                    lineList.push(new VertexPositionColor(v1, primitive.color.toVec4()));
                    lineList.push(new VertexPositionColor(v2, primitive.color.toVec4()));
                    lineList.push(new VertexPositionColor(v3, primitive.color.toVec4()));
                    indexList.push(count);
                    indexList.push(count + 1);
                    indexList.push(count);
                    indexList.push(count + 2);
                    indexList.push(count + 1);
                    indexList.push(count + 2);
                    count += 3;
                case AABB(v1, v2) :
                    lineList.push(new VertexPositionColor(v1, primitive.color.toVec4()));
                    lineList.push(new VertexPositionColor(new Vec3(v2.x, v1.y, v1.z), primitive.color.toVec4()));
                    lineList.push(new VertexPositionColor(new Vec3(v1.x, v2.y, v1.z), primitive.color.toVec4()));
                    lineList.push(new VertexPositionColor(new Vec3(v1.x, v1.y, v2.z), primitive.color.toVec4()));
                    lineList.push(new VertexPositionColor(new Vec3(v1.x, v2.y, v2.z), primitive.color.toVec4()));
                    lineList.push(new VertexPositionColor(new Vec3(v2.x, v1.y, v2.z), primitive.color.toVec4()));
                    lineList.push(new VertexPositionColor(new Vec3(v2.x, v2.y, v1.z), primitive.color.toVec4()));
                    lineList.push(new VertexPositionColor(v2, primitive.color.toVec4()));
                    indexList.push(count);
                    indexList.push(count + 1);
                    indexList.push(count);
                    indexList.push(count + 2);
                    indexList.push(count + 1);
                    indexList.push(count + 6);
                    indexList.push(count + 2);
                    indexList.push(count + 6);
                    indexList.push(count);
                    indexList.push(count + 3);
                    indexList.push(count + 1);
                    indexList.push(count + 5);
                    indexList.push(count + 2);
                    indexList.push(count + 4);
                    indexList.push(count + 6);
                    indexList.push(count + 7);
                    indexList.push(count + 3);
                    indexList.push(count + 5);
                    indexList.push(count + 3);
                    indexList.push(count + 4);
                    indexList.push(count + 5);
                    indexList.push(count + 7);
                    indexList.push(count + 4);
                    indexList.push(count + 7);
                    count += 8;
            }
        }

        // リストの内容を元に線を描画
        var arr = lineList.flatten().flatten().array();
        gd.arrayBufferData(vertexBufferLine, arr);
        gd.indexBufferData(indexBufferLine, indexList);

        gd.setVertexBuffer(vertexBufferLine);
        gd.setIndexBuffer(indexBufferLine);
        lineShader.useProgram();
        gd.uniformMatrix4fv(lineViewMatrixLocation, false, view);
        gd.uniformMatrix4fv(lineProjMatrixLocation, false, projection);
        gd.drawElements(RenderingContext.LINES, 0, indexList.length, VertexPositionColor.vertexDeclaration, lineShader);

        // 点の描画(線の描画が直ったらこちらも直す)
        pointShader.useProgram();
        gd.uniformMatrix4fv(pointViewMatrixLocation, false, view);
        gd.uniformMatrix4fv(pointProjMatrixLocation, false, projection);
        for(key in pointLists.keys()){
            var array = pointLists.get(key).flatten().flatten().array();
            gd.arrayBufferData(vertexBufferPoint, array);
            gd.setVertexBuffer(vertexBufferPoint);
            gd.uniform1f(pointSizeLocation, key);
            gd.drawArrays(RenderingContext.POINTS, 0, pointLists.get(key).length, VertexPositionColor.vertexDeclaration, pointShader);
        }
    primitives = new Array<Primitive>();
    skeltonPrimitives = new Array<Primitive>();
    }
}
