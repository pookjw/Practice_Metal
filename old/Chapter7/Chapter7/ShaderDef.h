//
//  ShaderDef.h
//  Chapter7
//
//  Created by Jinwoo Kim on 4/16/23.
//

#ifndef ShaderDef_h
#define ShaderDef_h

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float3 normal;
};

#endif /* ShaderDef_h */
