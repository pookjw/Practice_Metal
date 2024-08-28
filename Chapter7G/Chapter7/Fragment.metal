//
//  Fragment.metal
//  Chapter7
//
//  Created by Jinwoo Kim on 8/28/24.
//

#include <metal_stdlib>
using namespace metal;
#import "Common.h"

struct VertexOut {
    float4 position [[position]]; // 0~화면 크기 (-1~1 아님)
};

fragment float4 fragment_bw_half_main(constant Params &params [[buffer(12)]],
                              VertexOut in [[stage_in]]) {
    float color = step(params.width * 0.5, in.position.x);
    
    return float4(color, color, color, 1.f);
}

fragment float4 fragment_checker_board_main(constant Params &params [[buffer(12)]],
                                            VertexOut in [[stage_in]]) {
    uint checks = 8;
    
    // 좌표를 0과 1 사이로 변환
    float2 uv = in.position.xy / params.width;
    
    // fract(x) = x - floor(x)
    // fract(-0.4) = 0.6
    // fract(3.4) = 0.4
    uv = fract(uv * checks * 0.5f) - 0.5f;
    
    /*
     -0.5      0.0        0.5
      ---------------------  -0.5
     |          |          |
     |          |          |
     |    B     |     W    |
     |          |          |
      ---------------------
      ---------------------  0.0
     |          |          |
     |          |          |
     |    W     |     B    |
     |          |          |
      ---------------------  0.5
     */
    
    // X와 Y를 곱한 값이 0보다 크면 0, 작으면 1
    float3 color = step(uv.x * uv.y, 0.f);
    
    return float4(color, 1.f);
}

fragment float4 fragment_bw_circle_main(constant Params &params [[buffer(12)]],
                                        VertexOut in [[stage_in]]) {
    float center = 0.5f;
    float radius = 0.2f;
    
    // 좌표를 -0.5 부터 0.5 사이의 값으로 변경
    float2 uv = (in.position.xy / params.width) - center;
    
    // 원점 부터의 길이가 radius 보다 작으면 1, 크면 0
    float3 color = step(length(uv), radius);
    
    return float4(color, 1.f);
}

fragment float4 fragment_bw_gradient_main(constant Params &params [[buffer(12)]],
                                          VertexOut in [[stage_in]]) {
    /*
     https://en.wikipedia.org/wiki/Smoothstep
     
     float x, y, z
     
     float w = min(y, max(x, z)) / y;
     
     if (w <= 0) {
        return 0;
     } else if (w < 1.f) {
        return w * w * (3.f - 2.f * w);
     } else {
        return 1.f;
     }
     */
    float color = smoothstep(0.f, params.width, in.position.x);
    
//    float color;
//    float w = min(float(params.width), max(0.f, in.position.x)) / params.width;
//    
//    if (w <= 0.f) {
//        color = 0.f;
//    } else if (w < 1.f) {
//        color = w * w * (3.f - 2.f * w);
//    } else {
//        color = 1.f;
//    }
    
    return float4(color, color, color, 1.f);
}

fragment float4 fragment_gradient_1_main(constant Params &params [[buffer(12)]],
                                         VertexOut in [[stage_in]]) {
    float result = smoothstep(0, params.width, in.position.x);
    
    float3 red = float3(1.f, 0.f, 0.f);
    float3 blue = float3(0.f, 0.f, 1.f);
    
    // x + (y - x) * 0.6f
    float3 color = mix(red, blue, result);
    
    return float4(color, 1.f);
}

fragment float4 fragment_gradient_2_main(constant Params &params [[buffer(12)]],
                                         VertexOut in [[stage_in]]) {
//    float3 color = normalize(in.position.xyz);
    
    float3 color;
    float length = metal::length(in.position.xyz);
    color.x = in.position.x / length;
    color.y = in.position.y / length;
    color.z = in.position.z / length; // 0.f
    
    return float4(color, 1.f);
}
