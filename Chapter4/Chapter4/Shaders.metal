//
//  Shaders.metal
//  Chapter4
//
//  Created by Jinwoo Kim on 4/7/23.
//

#include <metal_stdlib>
using namespace metal;

//vertex float4 vertex_main(
//                          constant packed_float3 *vertices [[buffer(0)]],
//                          uint vertexId [[vertex_id]]
//                          )
//{
//    return float4(vertices[vertexId], 1);
//}

//vertex float4 vertex_main(
//                          constant packed_float3 *vertices [[buffer(0)]],
//                          constant ushort *indices [[buffer(1)]],
//                          constant float &timer [[buffer(11)]],
//                          uint vertexID [[vertex_id]]
//                          )
//{
//    ushort index = indices[vertexID];
//    float4 position = float4(vertices[index], 1);
//    position.y += timer;
//    return position;
//}

//vertex float4 vertex_main(
//                          float4 position [[attribute(0)]] [[stage_in]],
//                          constant float &timer [[buffer(1)]]
//                          )
//{
//    return position;
//}

//fragment float4 fragment_main() {
//    return float4(0.f, 0.f, 1.f, 1.f);
//}

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};
struct VertexOut {
    float4 position [[position]];
    float4 color;
};
vertex VertexOut vertex_main(
                          VertexIn in [[stage_in]],
                          constant float &timer [[buffer(11)]]
                          )
{
    float4 position = in.position;
    position.y += timer;
    
    VertexOut out {
        .position = position,
        .color = in.color
    };
    
    return out;
}

fragment float4 fragment_main(VertexOut out [[stage_in]]) {
    return out.color;
}
