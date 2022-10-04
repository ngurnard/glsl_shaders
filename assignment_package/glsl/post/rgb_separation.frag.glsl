#version 150

uniform ivec2 u_Dimensions;
uniform int u_Time;
uniform sampler2D u_RenderedTexture;

in vec2 fs_UV;

out vec3 color;

void main(void)
{
    // Material base color
    vec4 base_color = texture2D(u_RenderedTexture, fs_UV);
    float offset = 10;
    color = vec3(base_color.r + offset, base_color.g, base_color.b - offset);
}
