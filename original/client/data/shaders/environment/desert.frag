uniform float u_Time;
uniform sampler2D u_Tex0;
uniform sampler2D u_Tex1;
varying vec2 v_TexCoord;
uniform vec2 u_MapGlobalCoord;
uniform vec2 u_MapCenterCoord;
uniform mat3 u_TextureMatrix;
uniform float u_Opacity;
uniform float u_MapZoom;

vec2 direction = vec2(1.0,0.3);
float speed = 0.15;
float pressure = 0.4;
float zoom = 0.5;

void main(void)
{
    vec2 b = vec2(-u_TextureMatrix[1][1]/u_TextureMatrix[0][0], 1.0);
    vec2 offset = u_MapGlobalCoord + (v_TexCoord * b  + (direction * u_Time * (speed * u_MapZoom))) / u_MapZoom;
    vec3 bgcol = texture2D(u_Tex0, v_TexCoord).xyz;
    vec3 fogcol = texture2D(u_Tex1, offset).xyz * vec3(0.9, 0.8, 0.5);
    vec3 col = bgcol*(1.0-pressure) + fogcol*pressure;
    float len = length(v_TexCoord - u_MapCenterCoord)*1.0;
    vec3 mist = vec3(0.5,0.3,0.1);
    col = col +  mist * len;
    vec4 outcolor = vec4(col,1.0);
    gl_FragColor = outcolor * u_Opacity + (1.0 - u_Opacity) * vec4(bgcol, 1.0);
}