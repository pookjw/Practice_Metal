//
//  Shaders.metal
//  Chapter8
//
//  Created by Jinwoo Kim on 5/1/23.
//

#include <metal_stdlib>
#import "Common.h"
using namespace metal;

struct VertexIn {
    float4 position [[attribute(Position)]];
    float3 normal [[attribute(Normal)]];
    float2 uv [[attribute(UV)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 normal;
    float2 uv;
};

vertex VertexOut vertex_main(
                             const VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(UniformsBuffer)]]
                             )
{
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    float3 normal = in.normal;
    VertexOut out {
        .position = position,
        .normal = normal,
        .uv = in.uv
    };
    
    return out;
}

fragment float4 fragment_main(
                              constant Params &params [[buffer(ParamsBuffer)]],
                              const VertexOut in [[stage_in]]
                              )
{
    float4 sky = float4(0.34f, 0.9f, 1.f, 1.f);
    float4 earth = float4(0.29f, 0.58f, 0.2f, 1.f);
    float4 intensity = in.normal.y * 0.5f + 0.5f;
    return mix(earth, sky, intensity);
}
