attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vUv;
varying vec2 uv;

void main(void){
    uv = vUv;
    gl_Position = vec4(vPosition + vNormal, 1.);
}
