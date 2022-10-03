#version 150

uniform mat4 u_Model;
uniform mat3 u_ModelInvTr;
uniform mat4 u_View;
uniform mat4 u_Proj;

in vec4 vs_Pos;
in vec4 vs_Nor;

out vec3 fs_Nor;

out vec3 fs_LightVec;
uniform vec3 u_CamPos;

out vec3 offset;
out vec3 amp;
out vec3 freq;
out vec3 phase;

void main()
{
    // TODO Homework 4
    fs_Nor = normalize(u_ModelInvTr * vec3(vs_Nor));

    vec4 modelposition = u_Model * vs_Pos;

    gl_Position = u_Proj * u_View * modelposition;

    fs_LightVec = u_CamPos - modelposition.xyz;  // Compute the direction in which the light source lies

    // Custom Palette Numbers
    offset = vec3(1.000, 0.500, 0.500);
    amp = vec3(0.500, 0.500, 0.500);
    freq = vec3(0.750, 1.000, 2/3);
    phase = vec3(0.800, 1.000, 1/3);

//    offset = vec3(0.500, 0.500, 0.500);
//    amp = vec3(0.500, 0.500, 0.500);
//    freq = vec3(1.000, 1.000, 1.000);
//    phase = vec3(0.000, 0.333, 0.667);
}
