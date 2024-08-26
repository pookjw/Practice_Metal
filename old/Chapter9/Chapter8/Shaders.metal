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
                              const VertexOut in [[stage_in]],
                              const texture2d<float> baseColorTexture [[texture(BaseColor)]]
                              )
{
//    float4 sky = float4(0.34f, 0.9f, 1.f, 1.f);
//    float4 earth = float4(0.29f, 0.58f, 0.2f, 1.f);
//    float4 intensity = in.normal.y * 0.5f + 0.5f;
//    return mix(earth, sky, intensity);
    
    constexpr sampler textureSampler(
                                     filter::linear, // Texture의 화질이 낮을 경우 smoothing 처리. 안쪽 계단현상을 없앰
                                     address::repeat, // texture를 반복. 하단 grass
                                     mip_filter::linear, // 멀리 보이는 texture가 왜곡되는 것을 방지. 멀리 보일 수록 해상도를 낮춰서 부드럽게 함. TextureController에서 MTKTextureLoaderOptionGenerateMipmaps를 볼 것.
                                     max_anisotropy(8) // 끝부분 계단현상을 없앰
                                     );
    float3 baseColor = baseColorTexture.sample(
                                               textureSampler,
                                               in.uv * params.tiling // tiling = grass만 축소시킴
                                               ).rgb;
    return float4(baseColor, 1.f);
}
