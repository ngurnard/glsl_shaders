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

vec3 WorleyNoise(vec2 uv) {
    float scale = 55;
    uv *= scale; // Now the space is 10x10 instead of 1x1. Change this to any number you want.
    vec2 uvInt = floor(uv); // grid cells always lie on integer intervals on the x and y axis
    vec2 uvFract = fract(uv); // fract is uv - floor(uv); is just the fraction remainder
    float minDist = 10; // Minimum distance initialized to max of the grid cell diff.
    vec2 minPoint = uv;

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
//            float dist = abs(diff.x) + abs(diff.y); // l1 norm of the diff vector
            diff = abs(diff); float dist = max(diff.x, diff.y); // linf norm of the diff vector (Manhattan dist)

            // Update the closest attributes
            if (dist < minDist)
            {
                minDist = dist;
                minPoint = (uv + diff)/scale; // to get the color of the nearest neighbor
            }
        }
    }
    return vec3(minDist, minPoint.x, minPoint.y);
}

void main()
{
    // TODO Homework 5
//    color = vec3(0, 0, 0);

    // Randomize color diffs
//    color = rand3_in3(vec3(texelFetch(u_RenderedTexture, ivec2(gl_FragCoord.x, gl_FragCoord.y), 0)));

    // Material base color
    vec4 base_color = texture2D(u_RenderedTexture, fs_UV);

    // Ge the Worley noise of the 2d texture
    vec3 worley_out = WorleyNoise(fs_UV);
    worley_out.x = clamp(worley_out.x, 0, 1); // clamp distance to 1 if greater than 1

    // Modify the base color based on the minimum distance
//    base_color.x = mix(base_color.x, base_color.x * worley_out.x, 0.99);
//    base_color.y = mix(base_color.y, base_color.y * worley_out.x, 0.99);
//    base_color.z = mix(base_color.z, base_color.z * worley_out.x, 0.99);
    // Set the color for this fragment
//    color = vec3(base_color);

    // The color is based off the nearest neighbor from the WorleyNoise function output
    worley_out.y = clamp(worley_out.y * u_Dimensions.x, 0, u_Dimensions.x - 1); // make sure in image bounds
    worley_out.z = clamp(worley_out.z * u_Dimensions.y, 0, u_Dimensions.y - 1); // make sure in image bounds
//    color = vec3(texelFetch(u_RenderedTexture, vec2(worley_out.y, worley_out.z)), 0);
    color = vec3(texelFetch(u_RenderedTexture, ivec2(worley_out.y, worley_out.z), 0));

}
