//
//  Fragment.metal
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#include <metal_stdlib>
using namespace metal;
#import "ShaderDefs.h"

fragment float4 fragment_main(constant Params &params [[buffer(ParamsBuffer)]],
                              texture2d<float> baseColorTexture [[texture(BaseColor)]],
                              VertexOut in [[stage_in]])
{
    constexpr sampler textureSampler(filter::nearest,
                                     address::mirrored_repeat,
                                     mip_filter::nearest,
                                     max_anisotropy(8));
    float3 baseColor = baseColorTexture.sample(textureSampler, in.uv * params.tiling).rgb;
    return float4(baseColor, 1.f);
}
