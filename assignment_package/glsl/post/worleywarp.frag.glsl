#version 150

uniform ivec2 u_Dimensions;
uniform int u_Time;

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;

vec2 rand2( vec2 p ) {
    return fract( sin( vec2(dot(p, vec2(127.1, 311.7)),
                            dot(p, vec2(269.5,183.3))) ) * 43758.5453);
}

vec3 rand3_in2( vec2 p ) {
    return fract( sin( vec3(dot(p, vec2(127.1, 311.7)),
                            dot(p, vec2(269.5,183.3)),
                            dot(p, vec2(420.69, 69.420))) ) * 43758.5453);
}

vec3 rand3_in3( vec3 p ) {
    return fract( sin( vec3(dot(p, vec3(127.1, 311.7, 58.24)),
                            dot(p, vec3(269.5,183.3, 657.3)),
                            dot(p, vec3(420.69, 69.420, 469.20))) ) * 43758.5453);
}

vec3 WorleyNoise(vec2 uv, float lX_norm) {
    float scale = 55;
    uv *= scale; // Now the space is scale x scale instead of 1x1. Change this to any number you want.
    vec2 uvInt = floor(uv); // grid cells always lie on integer intervals on the x and y axis
    vec2 uvFract = fract(uv); // fract is uv - floor(uv); is just the fraction remainder
    float minDist = 1000; // Minimum distance initialized to max of the grid cell diff.
    float minDist2 = 1000;
    vec2 NN = uv; // nearest neighbor point!!
    vec2 NN2 = uv; // 2nd nearest neighbor point!!
    vec2 minDiff; // the vector between current fragment and the nearest neighbor pt
    vec2 minN; // the nearest neighbor cell direction

    // ------------------------------------------------------------
    // Classic voronoi
    // ------------------------------------------------------------
    for(int y = -1; y <= 1; ++y) {
        for(int x = -1; x <= 1; ++x) {
            vec2 neighbor = vec2(float(x), float(y)); // Direction in which neighbor cell lies
            vec2 point = rand2(uvInt + neighbor); // Get the Voronoi centerpoint for the neighboring cell
            point = 0.5 + 0.5 * sin(float(u_Time) * .1 + 6.2831 * point); // point now moves around!
            vec2 diff = neighbor + point - uvFract; // Distance between fragment coord and neighbor’s Voronoi point

            // ------------------------------------------------------------
            // Choose the distance calculation type below
            // ------------------------------------------------------------
//            float dist = length(diff); // l2 norm of the diff vector
//            float dist = abs(diff.x) + abs(diff.y); // l1 norm of the diff vector (Manhattan dist)
//            diff = abs(diff); float dist = max(diff.x, diff.y); // linf norm of the diff vector (Chebyshev distance)
            float dist = 0; // make it 8-bit style boxy

            if (lX_norm == 1)
            {
                float new_dist = 0; // 0 distance
                dist = new_dist;
            }
            else if (lX_norm == 0)
            {
                float new_dist = abs(diff.x) + abs(diff.y); // l1 norm of the diff vector (Manhattan dist)
                dist = new_dist;
            }
            else if (lX_norm == 2)
            {
                float new_dist = length(diff); // l2 norm of the diff vector
                dist = new_dist;
            }
            else
            {
                diff = abs(diff);
                float new_dist = max(diff.x, diff.y); // linf norm of the diff vector (Chebyshev distance)
                dist = new_dist;
            }

            // Update the closest attributes
            if (dist < minDist)
            {
                minDist2 = minDist; // distance to 2nd nearest neighbor
                minDist = dist; // distance to nearest neighbor
                NN2 = NN; // to get the color of the second nearest neighbor
                NN = (uv + diff)/scale; // to get the color of the nearest neighbor to make mosaic
                minDiff = diff; // the vector between current fragment and the nearest neighbor pt
                minN = neighbor; // the nearest neighbor cell direction
            }
        }
    }
    return vec3(NN.x, NN.y, minDist);
}

void main()
{
    // TODO Homework 5
    // Material base color
    vec4 base_color = texture2D(u_RenderedTexture, fs_UV);
    // Ge the Worley noise of the 2d texture
    float t = (cos(float(u_Time) * 0.005) + 1)/2; // u_Time increments by 1 every frame. Domain [0,1]
    t = floor(t * 4); // domain [0,5) then get only ints
    float lX_norm = t; // define glabally

    vec3 worley_out = WorleyNoise(fs_UV, lX_norm);
    float NN_dist = worley_out.z; // distance to nearest neighhbor
    NN_dist = clamp(NN_dist, 0, 1); // clamp distance to 1 if greater than 1
    vec2 NN = vec2(worley_out.x, worley_out.y); // nearest neighbor
    NN.x = clamp(NN.x * u_Dimensions.x, 0, u_Dimensions.x - 1); // make sure in image bounds
    NN.y = clamp(NN.y * u_Dimensions.y, 0, u_Dimensions.y - 1); // make sure in image bounds

    // The color is based off the nearest neighbor from the WorleyNoise function output
    color = vec3(texelFetch(u_RenderedTexture, ivec2(NN.x, NN.y), 0));
}
