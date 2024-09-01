//
//  Vertex.metal
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#include <metal_stdlib>
using namespace metal;
#import "ShaderDefs.h"

vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(UniformsBuffer)]])
{
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    
    VertexOut out = {
        .position = position,
        .normal = in.normal,
        .uv = in.uv
    };
    
    return out;
}
