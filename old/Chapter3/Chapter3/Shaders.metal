//
//  Shaders.metal
//  Chapter3
//
//  Created by Jinwoo Kim on 4/6/23.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

vertex float4 vertex_main(const VertexIn vertexIn [[stage_in]]) {
    return vertexIn.position;
}

fragment float4 fragment_main() {
    return float4(1, 0, 0, 1);
}
