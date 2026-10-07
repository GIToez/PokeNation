uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;
uniform float u_Time;
uniform vec2 u_Resolution;
uniform vec2 u_MapGlobalCoord;
uniform vec2 u_MapCenterCoord;
uniform mat3 u_TextureMatrix;
uniform float u_Opacity;
uniform float u_MapZoom;
const float PI = 3.1415926535897932;

// speed
const float speed = 0.01;
const float speed_x = 0.03;
const float speed_y = 0.02;

// geometry
const float intensity = 90.;
const int steps = 2;
const float frequency = 5.0;
const int angle = 7; // better when a prime

// reflection and emboss
const float delta = 300.;
const float intence = 1.2;
const float emboss = 0.1;

//---------- crystals effect
float col(vec2 coord)
{
    float delta_theta = 2.0 * PI / float(angle);
    float col = 0.0;
    float theta = 0.0;
    for(int i = 0; i < steps; i++) {
        vec2 adjc = coord;
        theta = delta_theta*float(i);
        adjc.x += cos(theta)*u_Time*speed + u_Time * speed_x;
        adjc.y -= sin(theta)*u_Time*speed - u_Time * speed_y;
        col = col + cos( (adjc.x*cos(theta) - adjc.y*sin(theta))*frequency)*intensity;
    }
    return cos(col);
}

void main(void)
{
    vec2 p = v_TexCoord, c1 = p, c2 = p;
    float cc1 = col(c1);

    c2.x += u_Resolution.x/delta;
    float dx = emboss*(cc1-col(c2))/delta;

    c2.x = p.x;
    c2.y += u_Resolution.y/delta;
    float dy = emboss*(cc1-col(c2))/delta;

    c1.x += dx;
    c1.y += dy;

    float alpha = 1.+dot(dx,dy)*intence;

    vec4 mist = vec4(0.9,0.3 + 0.2*sin(u_Time*0.5),0.0,1.0);
    float len = length(v_TexCoord - u_MapCenterCoord)*1.0;
    vec4 outcolor = (texture2D(u_Tex0,c1)*alpha) * 0.9;

    outcolor = outcolor  + mist * len * 0.8;
    gl_FragColor = outcolor * u_Opacity + (1.0 - u_Opacity) * texture2D(u_Tex0,v_TexCoord);
}