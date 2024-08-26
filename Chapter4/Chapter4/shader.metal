//
//  File.metal
//  Chapter4
//
//  Created by Jinwoo Kim on 8/26/24.
//

#include <metal_stdlib>
using namespace metal;

// float3은 16 bytes (float 4개, padding이 있음), packed_float3은 12 bytes (float 3개)
vertex float4 vertex_main(constant packed_float3 *vertices [[buffer(0)]],
                          constant float &timer [[buffer(11)]],
                          uint vertexID [[vertex_id]]) {
    float4 position = float4(vertices[vertexID], 1);
    position.y += timer;
    return position;
}

fragment float4 fragment_main() {
    return float4(0, 0, 1, 1);
}
