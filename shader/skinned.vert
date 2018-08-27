attribute vec3 Position;
attribute vec3 Normal;
attribute vec2 TextureCoordinate;
attribute vec4 BlendIndices;
attribute vec4 BlendWeight;
uniform mat4 transMatrix;
uniform mat4 viewMatrix;
uniform mat4 projMatrix;
uniform mat4 bones[72];
varying vec2 uv;
varying vec3 normal;
varying vec3 position;

mat4 skinningMatrix(){
    mat4 skinning = mat4(0);

    for(int i = 0; i < 4; i++){
        skinning += bones[int(BlendIndices[i])] * BlendWeight[i];
    }
    return skinning;
}

void main(void){
    uv = TextureCoordinate;
    normal = mat3(transMatrix) * Normal;
    position = Position;

    mat4 skinning = skinningMatrix();

    position = (skinning * vec4(position, 1.)).xyz;
    normal = mat3(skinning) * normal;

    gl_Position = projMatrix * viewMatrix * transMatrix * vec4(position, 1.);
}

