//
//  Shaders.metal
//  Project10
//
//  Created by Jinwoo Kim on 5/7/23.
//

#include <metal_stdlib>
#import "common.h"
using namespace metal;

struct VertexIn {
    float4 position [[attribute(Position)]];
    float3 normal [[attribute(Normal)]];
    float2 uv [[attribute(UV)]];
    float3 color [[attribute(Color)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 uv;
    float3 color;
};

vertex VertexOut vertex_main(
                             const VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(UniformsBuffer)]]
                             )
{
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    VertexOut out {
        .position = position,
        .uv = in.uv,
        .color = in.color
    };
    
    return out;
}

fragment float4 fragment_main(
                              const VertexOut in [[stage_in]],
                              constant Params &params [[buffer(ParamsBuffer)]],
                              texture2d<float> baseColorTexture [[texture(BaseColor)]]
                              )
{
    constexpr sampler textureSampler(
                                     filter::linear,
                                     address::repeat,
                                     mip_filter::linear,
                                     max_anisotropy(8)
                                     );
    
    float3 baseColor;
    if (is_null_texture(baseColorTexture)) {
        baseColor = in.color;
    } else {
        baseColor = baseColorTexture.sample(textureSampler, in.uv * params.tiling).rgb;
    }
    
    return float4(baseColor, 1.f);
}
