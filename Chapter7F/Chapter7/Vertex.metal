//
//  Vertex.metal
//  Chapter7
//
//  Created by Jinwoo Kim on 8/28/24.
//

#include <metal_stdlib>
using namespace metal;
#import "Common.h"
#import "ShaderDef.h"
#import "Common.h"

struct VertexIn {
    float4 position [[attribute(Position)]];
    float3 normal [[attribute(Normal)]];
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(UniformBuffer)]])
{
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    
    VertexOut out {
        .position = position,
        .normal = in.normal
    };
    
    return out;
}

constant float3 vertices[6] = {
    float3(-1.f, 1.f, 0.f),
    float3(1.f, -1.f, 0.f),
    float3(-1.f, -1.f, 0.f),
    float3(-1.f, 1.f, 0.f),
    float3(1.f, 1.f, 0.f),
    float3(1.f, -1.f, 0.f)
};

vertex VertexOut vertex_quad(uint vertexID [[vertex_id]]) {
    float4 position = float4(vertices[vertexID], 1.f);
    
    VertexOut out = {
        .position = position
    };
    
    return out;
}
