#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

const float kernel[121] = float[121](
0.006849, 0.007239, 0.007559, 0.007795, 0.007941, 0.00799, 0.007941, 0.007795, 0.007559, 0.007239, 0.006849,
0.007239, 0.007653, 0.00799, 0.00824, 0.008394, 0.008446, 0.008394, 0.00824, 0.00799, 0.007653, 0.007239,
0.007559, 0.00799, 0.008342, 0.008604, 0.008764, 0.008819, 0.008764, 0.008604, 0.008342, 0.00799, 0.007559,
0.007795, 0.00824, 0.008604, 0.008873, 0.009039, 0.009095, 0.009039, 0.008873, 0.008604, 0.00824, 0.007795,
0.007941, 0.008394, 0.008764, 0.009039, 0.009208, 0.009265, 0.009208, 0.009039, 0.008764, 0.008394, 0.007941,
0.00799, 0.008446, 0.008819, 0.009095, 0.009265, 0.009322, 0.009265, 0.009095, 0.008819, 0.008446, 0.00799,
0.007941, 0.008394, 0.008764, 0.009039, 0.009208, 0.009265, 0.009208, 0.009039, 0.008764, 0.008394, 0.007941,
0.007795, 0.00824, 0.008604, 0.008873, 0.009039, 0.009095, 0.009039, 0.008873, 0.008604, 0.00824, 0.007795,
0.007559, 0.00799, 0.008342, 0.008604, 0.008764, 0.008819, 0.008764, 0.008604, 0.008342, 0.00799, 0.007559,
0.007239, 0.007653, 0.00799, 0.00824, 0.008394, 0.008446, 0.008394, 0.00824, 0.00799, 0.007653, 0.007239,
0.006849, 0.007239, 0.007559, 0.007795, 0.007941, 0.00799, 0.007941, 0.007795, 0.007559, 0.007239, 0.006849
);

void main()
{
    // TODO Homework 5
    vec4 texelValue = texelFetch(u_RenderedTexture, ivec2(gl_FragCoord.x, gl_FragCoord.y), 0);
    for (int row = 0; row < 11; row++) // for each row of the 11x11 kernel
    {
        for (int col = 0; col < 11; col++) // for each col of the 11x11 kernel
        {
            float k = kernel[(row * 11) + col]; // get the kernel weight with the 1D coordinate
            vec4 texelValue_temp = texelFetch(u_RenderedTexture,
                                         ivec2(clamp(gl_FragCoord.x - 5 + col, 0, u_Dimensions.x - 1),
                                               clamp(gl_FragCoord.y - 5 + row, 0, u_Dimensions.y - 1)),
                                         0);
            float luminance = 0.21 * texelValue_temp.r + 0.72 * texelValue_temp.g + 0.07 * texelValue_temp.b;
            if (luminance > 0.55 && (row != 5 && col != 5))
            {
                texelValue += k * texelValue_temp;
            }
        }

    }
    color = texelValue.xyz;
}
