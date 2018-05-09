attribute vec3 Position;
attribute vec3 Normal;
attribute vec2 TextureCoordinate;
uniform mat4 transMatrix;
uniform mat4 viewMatrix;
uniform mat4 projMatrix;
varying vec2 uv;

void main(void){
    uv = TextureCoordinate;
    gl_Position = projMatrix * viewMatrix * transMatrix * vec4(Position + Normal, 1.);
}
