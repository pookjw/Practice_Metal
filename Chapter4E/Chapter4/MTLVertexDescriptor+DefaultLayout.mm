//
//  MTLVertexDescriptor+DefaultLayout.m
//  Chapter4
//
//  Created by Jinwoo Kim on 8/27/24.
//

#import "MTLVertexDescriptor+DefaultLayout.h"
#import "Quad.h"

@implementation MTLVertexDescriptor (DefaultLayout)

+ (instancetype)defaultLayout {
    MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor new];
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    vertexDescriptor.layouts[0].stride = sizeof(Vertex);
    
    vertexDescriptor.attributes[1].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[1].offset = 0;
    vertexDescriptor.attributes[1].bufferIndex = 1;
    vertexDescriptor.layouts[1].stride = sizeof(simd_float3);
    
    return [vertexDescriptor autorelease];
}

@end
