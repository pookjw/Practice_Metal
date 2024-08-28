//
//  Fragment.metal
//  Chapter7
//
//  Created by Jinwoo Kim on 8/28/24.
//

#include <metal_stdlib>
using namespace metal;
#import "Common.h"
#import "ShaderDef.h"
#import "Common.h"

fragment float4 fragment_main(constant Params &params [[buffer(ParamsBuffer)]],
                              VertexOut in [[stage_in]]) {
    float4 sky = float4(0.34f, 0.9f, 1.f, 1.f);
    float4 earth = float4(0.29f, 0.58f, 0.2f, 1.f);
    
    // -1~1 -> 0~1
    float intensity = in.normal.y * 0.5f + 0.5f;
    
    return mix(earth, sky, intensity);
}
