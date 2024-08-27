//
//  shader.metal
//  Chapter6
//
//  Created by Jinwoo Kim on 8/28/24.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]]) {
    float4 position = in.position;
    
    VertexOut out = {
        .position = position
    };
    
    return out;
}

fragment float4 fragment_main() {
    return float4(0.2f, 0.5f, 1.0f, 1.0f);
}
