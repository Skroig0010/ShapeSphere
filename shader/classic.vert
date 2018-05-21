attribute vec3 Position;
attribute vec3 Normal;
attribute vec2 TextureCoordinate;
uniform mat4 transMatrix;
uniform mat4 viewMatrix;
uniform mat4 projMatrix;
varying vec2 uv;
varying vec3 normal;
varying vec3 position;

void main(void){
    uv = TextureCoordinate;
    normal = mat3(transMatrix) * Normal;
    position = Position;
    gl_Position = projMatrix * viewMatrix * transMatrix * vec4(Position, 1.);
}
