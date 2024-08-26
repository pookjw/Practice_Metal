//
//  DebugLights.metal
//  Project10
//
//  Created by Jinwoo Kim on 5/17/23.
//

#include <metal_stdlib>
using namespace metal;
#import "../common.h"

struct VertexOut {
    float4 position [[position]];
    float point_size [[point_size]];
};

vertex VertexOut vertex_debug(
                              constant float3 *vertices [[buffer(0)]],
                              constant Uniforms &uniforms [[buffer(UniformsBuffer)]],
                              const uint id [[vertex_id]]
                              )
{
    matrix_float4x4 mvp = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix;
    return {
        .position = mvp * float4(vertices[id], 1.f),
        .point_size = 25.f
    };
}

fragment float4 fragment_debug_point(
                                     float2 point [[point_coord]],
                                     constant float3 &color [[buffer(1)]]
                                     )
{
    float d = distance(point, float2(0.5f, 0.5f));
    if (d > 0.5f) {
        discard_fragment();
    }
    
    return float4(color, 1.f);
}

fragment float4 fragment_debug_line(
                                    constant float3 &color [[buffer(1)]]
                                    )
{
    return float4(color, 1.f);
}
