//
//  Fragment.metal
//  Chapter7
//
//  Created by Jinwoo Kim on 8/28/24.
//

#include <metal_stdlib>
using namespace metal;
#import "Common.h"

struct VertexOut {
    float4 position [[position]];
};

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return float4(0.2f, 0.5f, 1.f, 1.f);
}
