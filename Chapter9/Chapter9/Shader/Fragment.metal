//
//  Fragment.metal
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#include <metal_stdlib>
#import "ShaderDef.h"

using namespace metal;

fragment float4 fragment_main(constant Params &params [[buffer(ParamsBuffer)]],
                              VertexOut in [[stage_in]],
                              texture2d<float> baseColorTexture [[texture(BaseColor)]])
{
    constexpr sampler textureSampler(filter::linear,
                                     mip_filter::linear,
                                     max_anisotropy(8),
                                     address::repeat);
    
    float3 baseColor = baseColorTexture.sample(textureSampler, in.uv * params.tiling).rgb;
    return float4(baseColor, 1.f);
}
