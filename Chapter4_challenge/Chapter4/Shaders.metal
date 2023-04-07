//
//  Shaders.metal
//  Chapter4
//
//  Created by Jinwoo Kim on 4/7/23.
//

#include <metal_stdlib>

using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float pointSize [[point_size]];
    float4 color;
};
vertex VertexOut vertex_main(
                             constant uint &count [[buffer(0)]],
                             constant float &timer [[buffer(11)]],
                             uint vertexID [[vertex_id]]
                             )
{
    float radius = 0.8f;
    float current = float(vertexID) / float(count);
    current += timer;
    
    float x = radius * cos(2 * M_PI_F * current);
    float y = radius * sin(2 * M_PI_F * current);
    float2 position = float2(x - timer, y - timer);
    
    VertexOut out {
        .position = float4(position, 0, 1),
        .pointSize = 30,
        .color = float4(1, 0, 0, 1)
    };
    
    return out;
}

fragment float4 fragment_main(VertexOut out [[stage_in]]) {
    return out.color;
}
