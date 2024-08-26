//
//  shader.metal
//  Chapter1
//
//  Created by Jinwoo Kim on 8/26/24.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

vertex float4 vertex_main(const VertexIn vertex_in [[stage_in]]) {
    return vertex_in.position;
}

fragment float4 fragment_main() {
    return float4(1., 0., 0., 1.);
}
