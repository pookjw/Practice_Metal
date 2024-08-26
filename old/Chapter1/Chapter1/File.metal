//
//  File.metal
//  Chapter1
//
//  Created by Jinwoo Kim on 4/6/23.
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
    return float4(0.f, 0.4f, 0.21f, 1.f);
}
