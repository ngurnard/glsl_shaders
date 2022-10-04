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

    /*
    NOTES TO MYSELF:
    Texture coordinates may be normalized or in texel space. A normalized texture coordinate means
    that the size of the texture maps to the coordinates on the range [0, 1] in each dimension.
    This allows the texture coordinate to be independent of any particular texture's size.
    A texel-space texture coordinate means that the coordinates are on the range [0, size],
    where size​ is the size of the texture in that dimension.
    */
    /*
    texelFetch(sampler, P, lod);
    first argument "sampler" is just a texture.
    second argument is the coordinate in the texture map coords UNORMALIZED
    For lod, it means the level of detail in the mipmap. We can simply use 0 for the base level (the original size)
    */

    // NOTE: oneDindex = (row * length_of_row) + column; // Indexes

    // NOTE: gl_FragCoord contains the window-relative coordinates of the current fragment

    vec4 texelValue = vec4(0, 0, 0, 0);
    for (int row = 0; row < 11; row++) // for each row of the 11x11 kernel
    {
        for (int col = 0; col < 11; col++) // for each col of the 11x11 kernel
        {
            float k = kernel[(row * 11) + col]; // get the kernel weight with the 1D coordinate
            texelValue += k * texelFetch(u_RenderedTexture,
                                         ivec2(clamp(gl_FragCoord.x - 5 + col, 0, u_Dimensions.x - 1),
                                               clamp(gl_FragCoord.y - 5 + row, 0, u_Dimensions.y - 1)),
                                         0);
        }

    }

    color = texelValue.xyz;

}
