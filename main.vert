attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vUv;
uniform mat4 transMatrix;
uniform mat4 viewMatrix;
uniform mat4 projMatrix;
varying vec2 uv;

void main(void){
    uv = vUv;
    gl_Position = projMatrix * viewMatrix * transMatrix * vec4(vPosition + vNormal, 1.);
}
