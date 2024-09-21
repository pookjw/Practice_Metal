//
//  Vertex.metal
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#include <metal_stdlib>
#import "ShaderDef.h"

using namespace metal;

vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(UniformsBuffer)]])
{
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
    
    VertexOut out {
        .position = position,
        .normal = in.normal,
        .uv = in.uv
    };
    
    return out;
}
