//
//  Shaders.metal
//  Chapter4
//
//  Created by Jinwoo Kim on 4/7/23.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 vertex_main(
                          constant packed_float3 *vertices [[buffer(0)]],
                          uint vertexID [[vertex_id]]
                          ) {
    return float4(vertices[vertexID], 1);
}

fragment float4 fragment_main() {
    return float4(0.f, 0.f, 1.f, 1.f);
}
