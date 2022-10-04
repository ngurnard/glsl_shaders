#version 150

uniform mat4 u_Model;
uniform mat3 u_ModelInvTr;
uniform mat4 u_View;
uniform mat4 u_Proj;

uniform int u_Time;

in vec4 vs_Pos;
in vec4 vs_Nor;
uniform vec3 u_CamPos; // get the camera position

out vec3 fs_Pos;
out vec3 fs_Nor;
out vec3 fs_LightVec;

void main()
{
    // TODO Homework 4
    fs_Nor = normalize(u_ModelInvTr * vec3(vs_Nor));

    vec4 modelposition = u_Model * vs_Pos;

    // To get the iridescent coloring on the mario surface
    fs_LightVec = u_CamPos - modelposition.xyz;  // Compute the direction in which the light source lies

    // define an oscillating time so that model can transition back and forth
    float t = (cos(float(u_Time) * 0.05) + 1)/2; // u_Time increments by 1 every frame. Domain [0,1]
    t = clamp(t, 0.0, 0.96); // prevent z-fighting when infinitely thin cone surface

    // We want the model to turn into a cone
    float h = 4; // cone height
    float slope = 3; // magnitude of slope of the surface of the cone on the xy plane cross section
    float radius = (h - modelposition.y) / slope;

    // Get the point on the cone surface for this height plane for this vertex
    vec2 cone_pt_xz = radius * normalize(modelposition.xz);

    // Interpolate between current model pt and the cone_pt
    modelposition.x = mix(modelposition.x, cone_pt_xz.x, t);
    modelposition.z = mix(modelposition.z, cone_pt_xz.y, t);

    // Now be sure to send the deformation to the fragment shader
    fs_Pos = vec3(modelposition);
    gl_Position = u_Proj * u_View * modelposition;
}
