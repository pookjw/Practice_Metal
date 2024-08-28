//
//  ShaderDef.h
//  Chapter7
//
//  Created by Jinwoo Kim on 8/29/24.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float3 normal;
};
