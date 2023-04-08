//
//  TriangleShader.metal
//  Chapter5
//
//  Created by Jinwoo Kim on 4/9/23.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut triangle_vertex_main(
                                      VertexIn in [[stage_in]],
                                      constant float3 &position [[buffer(11)]]
                                      )
{
    float3 translation = in.position.xyz + position;
    VertexOut out {
        .position = float4(translation, 1)
    };
    return out;
}

fragment float4 triangle_fragment_main(
                                       constant float4 &color [[buffer(0)]]
                                       )
{
    return color;
}
