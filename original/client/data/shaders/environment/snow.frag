uniform sampler2D u_Tex0;
uniform sampler2D u_Tex1;
uniform sampler2D u_Tex2;
varying vec2 v_TexCoord;
uniform vec2 u_Resolution;
uniform float u_Time;
uniform float u_Opacity;
uniform mat3 u_TextureMatrix;
uniform vec2 u_MapGlobalCoord;
uniform vec2 u_MapCenterCoord;
uniform float u_MapZoom;

vec2 snow_direction = vec2(-1.0,1.0);
float snow_speed = 0.25;
float snow_pressure = 0.2;
float snow_zoom = 1.0;

vec2 fog_direction = vec2(1.0,1.0);
float fog_speed = 0.75;
float fog_pressure = 0.3;
float fog_zoom = 0.2;

vec4 mistcolor = vec4(1.0,1.0,1.0,1.0);
float mist_pressure = 0.3;
float bg_pressure = 0.7;

void main(void)
{
    vec2 b = vec2(-u_TextureMatrix[1][1]/u_TextureMatrix[0][0], 1.0);
    vec2 snow_offset = u_MapGlobalCoord + (v_TexCoord * b  + (snow_direction * u_Time * (snow_speed * u_MapZoom * snow_zoom))) / u_MapZoom;
    vec2 fog_offset = u_MapGlobalCoord + (v_TexCoord * b  + (fog_direction * u_Time * (fog_speed * u_MapZoom * fog_zoom))) / u_MapZoom;
    vec4 snowcol = texture2D(u_Tex1, snow_offset) * snow_pressure;
    vec4 fogcol = texture2D(u_Tex2, fog_offset) * fog_pressure;
    vec4 color = texture2D(u_Tex0,v_TexCoord);
    float len = length(v_TexCoord - u_MapCenterCoord)*1.0;
    vec4 mistcol = mistcolor * len * mist_pressure;
    vec4 outcolor = color * bg_pressure +  snowcol + fogcol + mistcol;
    gl_FragColor = outcolor * u_Opacity + (1.0 - u_Opacity) * color;
}