//
//  Vertex.metal
//  Chapter7
//
//  Created by Jinwoo Kim on 4/14/23.
//

#include <metal_stdlib>
#import "Common.h"
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut vertex_main(
                             VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(11)]]
                             )
{
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    VertexOut out {
        .position = position
    };
    return out;
}

constant float3 vertices[6] = {
    float3(-1.f,  1.f,  0.f),    // triangle 1
    float3( 1.f, -1.f,  0.f),
    float3(-1.f, -1.f,  0.f),
    float3(-1.f,  1.f,  0.f),    // triangle 2
    float3( 1.f,  1.f,  0.f),
    float3( 1.f, -1.f,  0.f)
};

vertex VertexOut vertex_quad(uint vertexID [[vertex_id]]) {
    float4 position = float4(vertices[vertexID], 1.f);
    VertexOut out {
        .position = position
    };
    return out;
}
