#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader
uniform int u_Time;

in vec3 fs_Pos;
in vec3 fs_Nor;
in vec3 fs_LightVec;

layout(location = 0) out vec3 out_Col;

void main()
{
    // TODO Homework 4
    out_Col = vec3(0, 0, 0);

    // Calculate the diffuse term for Lambert shading (the t variable)
    float t = (cos(dot(normalize(fs_Nor), normalize(fs_LightVec)) * (cos(float(u_Time) * 0.05) + 1.5)*10) + 1)/2;

    // Custom Palette Numbers
    vec3 offset = vec3(1.000, 0.500, 0.500);
    vec3 amp = vec3(0.500, 0.500, 0.500);
    vec3 freq = vec3(0.750, 1.000, 2/3);
    vec3 phase = vec3(0.800, 1.000, 1/3);

    // define an oscillating time so that model can transition back and forth
//    float t = (cos(float(u_Time) * 0.05) + 1)/2; // u_Time increments by 1 every frame. Domain [0,1]

    out_Col = vec3(offset.x + amp.x * cos(2 * 3.14159 * (freq.x * t + phase.x)),
                   offset.y + amp.y * cos(2 * 3.14159 * (freq.y * t + phase.y)),
                   offset.z + amp.z * cos(2 * 3.14159 * (freq.z * t + phase.z)));
}
