//
//  shader.metal
//  Chapter5
//
//  Created by Jinwoo Kim on 8/27/24.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant float4x4 &matrix [[buffer(11)]])
{
    float4 translation = matrix * in.position;
    VertexOut out {
        .position = translation
    };
    return out;
}

fragment float4 fragment_main(constant float4 &color [[buffer(0)]]) {
    return color;
}

vertex float4 vertex_grid_main(float4 position [[attribute(0)]] [[stage_in]]) {
    return float4(position.xyz, 1.f);
}

fragment float4 fragment_grid_main() {
    return float4(0.f, 0.f, 0.f, 1.f);
}
