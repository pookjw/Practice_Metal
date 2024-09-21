//
//  ShaderDef.h
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#include <metal_stdlib>
#import "../Common.h"
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
