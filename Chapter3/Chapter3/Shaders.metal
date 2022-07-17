//
//  Shaders.metal
//  Chapter3
//
//  Created by Jinwoo Kim on 7/17/22.
//

#include <metal_stdlib>
#import "Common.h"

using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

//vertex float4 vertex_main(const VertexIn vertexIn [[stage_in]], constant float &timer [[buffer(1)]]) {
//    float4 position = vertexIn.position;
//    position.x += timer;
//    return position;
//}

vertex float4 vertex_main(const VertexIn vertexIn [[stage_in]], constant Uniforms &uniforms [[buffer(1)]]) {
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertexIn.position;
    return position;
}

fragment float4 fragment_main() {
    return float4(0, 0, 1, 1);
}
