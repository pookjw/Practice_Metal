//
//  GridShader.metal
//  Chapter5
//
//  Created by Jinwoo Kim on 4/8/23.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 grid_vertex_main(
                          simd_float3 position [[attribute(0)]] [[stage_in]]
                          )
{
//    simd_float3 position = vertices[vertexID];
    return float4(position.x, position.y, position.z, 1.f);
//    return float4(position, 1.f);
}

fragment float4 grid_fragment_main() {
    return float4(1.f, 0.f, 0.f, 1.f);
}
