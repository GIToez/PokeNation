uniform float u_Time;
uniform float u_Opacity;
uniform sampler2D u_Tex0;
uniform mat3 u_TextureMatrix;
varying vec2 v_TexCoord;
uniform vec2 u_MapCenterCoord;

float dist = 0.003;
float original_pressure = 0.5;
float center_pressure = 0.15;
float border_pressure = 0.9;
int passes = 4;

//15:45 You see a porygon ground. ID: 12655. Position(X: 3520 Y: 3691 Z: 8). Dat id:11899. Ground id:12655
void main()
{
    vec2 b = vec2(-u_TextureMatrix[1][1]/u_TextureMatrix[0][0], 1.0);
    vec3 color = texture2D(u_Tex0, v_TexCoord).rgb;
    vec3 sum = color * original_pressure;
    float len = length(v_TexCoord - u_MapCenterCoord);
    float percent = (len*len);
    float pp = (center_pressure + (border_pressure/4.0) * percent) / float(passes);
    for(int i=0;i<passes;++i) {
        vec2 mul = b*dist*float(i)*(1.0-percent);
        sum += texture2D(u_Tex0, v_TexCoord + vec2( 0.0, -1.0)*mul).rgb * pp;
        sum += texture2D(u_Tex0, v_TexCoord + vec2(-1.0,  0.0)*mul).rgb * pp;
        sum += texture2D(u_Tex0, v_TexCoord + vec2( 0.0,  1.0)*mul).rgb * pp;
        sum += texture2D(u_Tex0, v_TexCoord + vec2( 1.0,  0.0)*mul).rgb * pp;
    }
    gl_FragColor = vec4(mix(color, sum, u_Opacity),1);
}