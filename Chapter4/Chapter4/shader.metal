//
//  File.metal
//  Chapter4
//
//  Created by Jinwoo Kim on 8/26/24.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 vertex_main(constant packed_float3 *vertices [[buffer(0)]],
                          uint vertexID [[vertex_id]]) {
    float4 position = float4(vertices[vertexID], 1);
    return position;
}

fragment float4 fragment_main() {
    return float4(0, 0, 1, 1);
}
