//
//  MDLVertexDescriptor+Category.m
//  Project6
//
//  Created by Jinwoo Kim on 4/13/23.
//

#import "MDLVertexDescriptor+Category.h"

@implementation MDLVertexDescriptor (Category)

+ (MDLVertexDescriptor *)defaultLayout {
    NSUInteger offset = 0;
    
    MDLVertexDescriptor *vertexDescriptor = [MDLVertexDescriptor new];
    vertexDescriptor.attributes[0] = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributePosition
                                                                       format:MDLVertexFormatFloat3
                                                                       offset:0
                                                                  bufferIndex:0];
    
    offset += sizeof(simd_float3);
    
    vertexDescriptor.attributes[1] = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeNormal
                                                                       format:MDLVertexFormatFloat3
                                                                       offset:offset
                                                                  bufferIndex:0];
    
    offset += sizeof(simd_float3);
    
    vertexDescriptor.layouts[0] = [[MDLVertexBufferLayout alloc] initWithStride:offset];
    
    return vertexDescriptor;
}

@end
