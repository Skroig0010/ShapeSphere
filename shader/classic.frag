precision mediump float;
uniform sampler2D texture;
uniform vec4 color;
varying vec3 position;
varying vec2 uv;
varying vec3 normal;

void main(void){
    vec3 lightDir = normalize(vec3(0,0,-1));
    vec3 toCamera = normalize(position - vec3(0, 0, 0));
    vec3 lightRef = reflect(lightDir, normalize(normal));
    float amb = 0.5;
    float dif = max(0., dot(normalize(normal), lightDir));
    float spc = pow(max(0., dot(toCamera, lightRef)), 10.);
    gl_FragColor = vec4((amb + dif) + color.xyz * 0.0 + spc * 0.1, 1) * texture2D(texture, uv);
    // gl_FragColor = vec4((amb + dif) * color.xyz + spc * 0.1, 1);
}
