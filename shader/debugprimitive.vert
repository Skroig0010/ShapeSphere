attribute vec3 Position;
attribute vec4 Color;
uniform mat4 viewMatrix;
uniform mat4 projMatrix;
varying vec4 color;

void main(void){
    color = Color;
    gl_Position = projMatrix * viewMatrix * vec4(Position, 1.);
}
