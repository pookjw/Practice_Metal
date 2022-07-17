#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float point_size [[point_size]];
};

//vertex float4 vertex_main() {
//  return float4(0);
//}
//
//fragment float4 fragment_main() {
//  return float4(0);
//}

//vertex VertexOut vertex_main(constant float3 *vertices [[buffer(0)]], uint id [[vertex_id]]) {
//    VertexOut vertex_out {
//        .position = float4(vertices[id], 1),
//        .point_size = 20.0
//    };
//    return vertex_out;
//}

vertex VertexOut vertex_main(constant float3 *vertices [[buffer(0)]], constant float4x4 &matrix [[buffer(1)]], uint id [[vertex_id]]) {
    VertexOut vertex_out {
        .position = matrix * float4(vertices[id], 1),
        .point_size = 20.0
    };
    return vertex_out;
}

fragment float4 fragment_main(constant float4 &color [[buffer(0)]]) {
    return color;
}
