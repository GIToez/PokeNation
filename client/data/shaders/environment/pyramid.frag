uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;
uniform vec2 u_Resolution;
uniform float u_Time;
uniform float u_Opacity;
uniform vec2 u_MapCenterCoord;

void main(void)
{
    vec4 color = texture2D(u_Tex0,v_TexCoord);
    vec4 mist = vec4(0.5,0.4,0.1,1);
    float len = length(v_TexCoord - u_MapCenterCoord)*1.0;
    vec4 outcolor = color * (1.0-len) +  mist * len * 1.5;
    gl_FragColor = outcolor * u_Opacity + (1.0 - u_Opacity) * color;
}