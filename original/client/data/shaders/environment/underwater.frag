uniform sampler2D u_Tex0;
uniform sampler2D u_Tex1;
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
const float speed = 0.06;
const float speed_x = 0.03;
const float speed_y = 0.02;

// geometry
const float intensity = 30.;
const int steps = 5;
const float frequency = 0.5;
const int angle = 7; // better when a prime

// reflection and emboss
const float delta = 100.;
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
    float pressure = 0.3;

    vec2 direction = vec2(1.0,-1.0);
    float speed = 0.05;
    vec4 mist = vec4(0.2,0.2,0.3,1.0);
    float len = length(v_TexCoord - u_MapCenterCoord)*1.0;
    vec4 outcolor = (texture2D(u_Tex0,c1)*alpha + 0.3*vec4(0.1,0.2,0.8,1.0)) * 0.8 * (1.0 - len)  + mist * len * len * 1.4;
    vec2 b = vec2(-u_TextureMatrix[1][1]/u_TextureMatrix[0][0], 1.0);
    vec2 offset = (u_MapGlobalCoord + (v_TexCoord * b  + (direction * u_Time * (speed * u_MapZoom))) / u_MapZoom) / 0.6;
    vec4 fogcol = texture2D(u_Tex1, offset);
    outcolor = outcolor + fogcol*(0.04 + (1.0+sin(u_Time))*0.02);
    gl_FragColor = outcolor * u_Opacity + (1.0 - u_Opacity) * texture2D(u_Tex0,v_TexCoord);
}