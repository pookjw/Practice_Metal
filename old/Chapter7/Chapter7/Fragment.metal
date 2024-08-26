//
//  Fragment.metal
//  Chapter7
//
//  Created by Jinwoo Kim on 4/14/23.
//

#include <metal_stdlib>
#import "Common.h"
#import "ShaderDef.h"
using namespace metal;

fragment float4 fragment_main(
                              constant Params &params [[buffer(12)]],
                              VertexOut in [[stage_in]]
                              )
{
#pragma mark - 파란색
//    return float4(0.2f, 0.5f, 1.f, 1.f);
    
#pragma mark - 절반 기준으로 흑백
//    float color;
//    in.position.x < params.width * 0.5f ? color = 0 : color = 1;
//    return float4(color, color, color, 1.f);
    
    // is equivalent to
//    float color = step(params.width * 0.5f, in.position.x);
//    /*
//     step(x, y)
//     x < y returns 1
//     x > y returns 0
//     */
//    return float4(color, color, color, 1.f);
    
#pragma mark - 체스판
//    uint checks = 5; // 가로 block 개수
//    float2 uv = in.position.xy / params.width; // 좌표를 width로 나눈다. x는 0~1이며, y는 x보다 작으면 1보다 작을 것이고 x보다 크면 1보다 클 것이다.
//
//    /*
//     만약 checks가 5라고 가정하자
//     그러면 width 기준으로 checks의 x 좌표들은 0/5, 1/5, 2/5, 3/5, 4/5가 될 것이다.
//     checks를 곱하면 0~4가 될 것이다. 모두 자연수일 것이다. 여기에 0.5를 곱하고 fract를 입히고 0.5를 빼면
//     짝수는 -0.5, 홀수는 0이 나올 것이다.
//     */
//    uv = fract(uv * checks * 0.5f) - 0.5f;
//
//    // 하나의 row (uv.x) 기준으로 보면 uv.y는 check이 증가하면서 -0.5, 0을 switch 한다.
//    float3 color = step(uv.x * uv.y, 0.f);
//    return float4(color, 1.f);
    
#pragma mark - 원
//    float center = 0.5f;
//    float radius = 0.2f;
//    float2 uv = in.position.xy / params.width - center;
//    float3 color = step(length(uv), radius); // length = sqrt(x^2 + y^2)
//    return float4(color, 1.f);
    
#pragma mark - Gradient (Block & White)
    // start, end, current
//    float color = smoothstep(0.f, params.width, in.position.x);
//    return float4(color, color, color, 1.f);
    
#pragma mark - Mix 1
    // mix(x, y, a) produces the same results as x + (y - x) * a
//    float3 red = float3(1.f, 0.f, 0.f);
//    float3 blue = float3(0.f, 0.f, 1.f);
//    float3 color = mix(red, blue, 0.6f);
//    return float4(color, 1.f);
    
#pragma mark - Mix 2 (Red & Blue)
//    float3 red = float3(1.f, 0.f, 0.f);
//    float3 blue = float3(0.f, 0.f, 1.f);
//    float result = smoothstep(0.f, params.width, in.position.x);
//    float3 color = mix(red, blue, result);
//    return float4(color, 1.f);
    
#pragma mark - Normalize
//    float3 color = normalize(in.position.xyz); // length(vector) = 1.0인 단일벡터로 변환
//    return float4(color, 1);
    
#pragma mark - Depth - XYZ에서 빛이 투영될 때 normal이 계산되어서 들어 옴
//    return float4(in.normal, 1.f);
    
#pragma mark - Depth 빛을 합성
    float4 sky = float4(0.34f, 0.9f, 1.f, 1.f);
    float4 earth = float4(0.29f, 0.58f, 0.2f, 1.f);
    float intensity = in.normal.y * 0.5f + 0.5f;
    
    // x + (y - x) * a
    return mix(earth, sky, intensity);
}
