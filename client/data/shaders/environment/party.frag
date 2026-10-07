uniform float u_Time;
uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;
uniform float u_Opacity;

void main()
{
    vec4 col = texture2D(u_Tex0, v_TexCoord);
    float d = u_Time * 2.0;
    vec4 outcol = col;
    float fact = 0.1;
    float fa = 0.5;
    outcol.x = (1.0 + sin(d))*fa*col.x + col.x*fact;
    outcol.y = (1.0 + sin(d*2.0))*fa*col.y + col.y*fact;
    outcol.z = (1.0 + sin(d*4.0))*fa*col.z + col.z*fact;
    gl_FragColor = outcol * u_Opacity + (1.0 - u_Opacity) * col;
}