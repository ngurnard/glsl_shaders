#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec2 fs_UV;

layout(location = 0) out vec3 out_Col;

void main()
{
    // TODO Homework 4
    // ----------------------------------------------------
    // Matcap Reflection Shading
    // ----------------------------------------------------
    // Material base color (before shading)
    vec4 diffuseColor = texture(u_Texture, fs_UV);
    // Compute final shaded color
    out_Col = vec3(diffuseColor.rgb);
}
