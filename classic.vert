attribute vec3 Position;
attribute vec3 Normal;
uniform mat4 transMatrix;
uniform mat4 viewMatrix;
uniform mat4 projMatrix;

void main(void){
    gl_Position = projMatrix * viewMatrix * transMatrix * vec4(Position + Normal, 1.);
}
