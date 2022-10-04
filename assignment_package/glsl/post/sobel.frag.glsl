#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

const float kernel_hor[9] = float[9](3, 0, -3, 10, 0, -10, 3, 0, -3);
const float kernel_vert[9] = float[9](3, 10, 3, 0, 0, 0, -3, -10, -3);

void main()
{
    // TODO Homework 5
    vec4 texelValue_hor = vec4(0, 0, 0, 0);
    vec4 texelValue_vert = vec4(0, 0, 0, 0);
    for (int row = 0; row < 3; row++) // for each row of the 11x11 kernel
    {
        for (int col = 0; col < 3; col++) // for each col of the 11x11 kernel
        {
            float k_hor = kernel_hor[(row * 3) + col]; // get the kernel weight with the 1D coordinate
            float k_vert = kernel_vert[(row * 3) + col]; // get the kernel weight with the 1D coordinate
            texelValue_hor += k_hor * texelFetch(u_RenderedTexture,
                                         ivec2(clamp(gl_FragCoord.x - 1 + col, 0, u_Dimensions.x - 1),
                                               clamp(gl_FragCoord.y - 1 + row, 0, u_Dimensions.y - 1)),
                                         0);
            texelValue_vert += k_vert * texelFetch(u_RenderedTexture,
                                         ivec2(clamp(gl_FragCoord.x - 1 + col, 0, u_Dimensions.x - 1),
                                               clamp(gl_FragCoord.y - 1 + row, 0, u_Dimensions.y - 1)),
                                         0);
        }

    }

    color = vec3(sqrt(pow(texelValue_hor.x, 2) + pow(texelValue_vert.x, 2)),
                 sqrt(pow(texelValue_hor.y, 2) + pow(texelValue_vert.y, 2)),
                 sqrt(pow(texelValue_hor.z, 2) + pow(texelValue_vert.z, 2)));
}
