#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec3 fs_Nor;
in vec3 fs_LightVec;

in vec3 offset;
in vec3 amp;
in vec3 freq;
in vec3 phase;

layout(location = 0) out vec3 out_Col;

void main()
{
    // TODO Homework 4

    // Calculate the diffuse term for Lambert shading (the t variable)
    float t = dot(normalize(fs_Nor), normalize(fs_LightVec));
    t = clamp(t, 0, 1);

    out_Col = vec3(offset.x + amp.x * cos(2 * 3.14159 * (freq.x * t + phase.x)),
                   offset.y + amp.y * cos(2 * 3.14159 * (freq.y * t + phase.y)),
                   offset.z + amp.z * cos(2 * 3.14159 * (freq.z * t + phase.z)));
}
