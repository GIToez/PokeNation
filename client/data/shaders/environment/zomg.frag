uniform sampler2D u_Tex0;
uniform float u_Time;
uniform float u_Opacity;
varying vec2 v_TexCoord;
uniform vec2 u_MapGlobalCoord;
uniform vec2 u_MapCenterCoord;
uniform mat3 u_TextureMatrix;
uniform float u_MapZoom;

vec2 dir45 = vec2(1.0, 1.0);
float init = 0.1;
float range = 0.3;
float motion_range = 0.2;

void main(void)
{
    float fade = u_Opacity + u_Opacity * sin(u_Time) * motion_range;
    vec2 dir = u_MapCenterCoord - v_TexCoord;
    float dist = sqrt(dir.x*dir.x + dir.y*dir.y);
    float scale = (1.0 - (init * fade)) + (dist*dist*range*fade);
    vec4 color = texture2D(u_Tex0, -(dir*scale - u_MapCenterCoord));
    gl_FragColor = color;
}

/*
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;
uniform vec2 u_Resolution;
uniform vec2 u_MapCenterCoord;
uniform vec2 u_MapGlobalCoord;

void main(void)
{
    vec4 color = texture2D(u_Tex0,v_TexCoord);
    float len = length(v_TexCoord - u_MapCenterCoord);
    if(len < 0.01) {
        color = vec4(0,0,0,1); }
    gl_FragColor = color;
}
*/