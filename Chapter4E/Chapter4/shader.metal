//
//  File.metal
//  Chapter4
//
//  Created by Jinwoo Kim on 8/26/24.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float pointSize [[point_size]];
    float4 color;
};

// float3은 16 bytes (float 4개, padding이 있음), packed_float3은 12 bytes (float 3개)
vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                          constant float &timer [[buffer(11)]],
                          uint vertexID [[vertex_id]]) {
    float4 position = in.position;
    position.y += timer;
    
    return {
        .position = position,
        .color = in.color,
        .pointSize = 30
    };
}

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return in.color;
}
