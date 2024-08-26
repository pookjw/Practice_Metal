//
//  File.metal
//  Chapter4
//
//  Created by Jinwoo Kim on 8/26/24.
//

#include <metal_stdlib>
using namespace metal;

constant constexpr float M_PI = 3.14159265358979323846264338327950288;

struct VertexOut {
    float4 position [[position]];
    float pointSize [[point_size]];
    float4 color;
};

vertex VertexOut vertex_main(constant short &count [[buffer(0)]],
                          constant float &timer [[buffer(11)]],
                          uint vertexID [[vertex_id]]) {
    float radian = M_PI * 2. * (float(vertexID) / float(count)) + timer;
    
    float4 position = {
        cos(radian) * 0.8f,
        sin(radian) * 0.8f,
        0,
        1
    };
    
    return {
        .position = position,
        .pointSize = 30,
        .color = {
            1.f - (sin(timer) + 1.f) / 2.f,
            (sin(timer + M_PI * 3.f / 2.f) + 1.f) / 2.f,
            (sin(timer + M_PI / 2.f) + 1.f) / 2.f,
            1.f
        }
    };
}

fragment float4 fragment_main(VertexOut out [[stage_in]]) {
    return out.color;
}
