//
//  MDLVertexDescriptor+Category.m
//  Project6
//
//  Created by Jinwoo Kim on 4/13/23.
//

#import "MDLVertexDescriptor+Category.h"

@implementation MDLVertexDescriptor (Category)

+ (MDLVertexDescriptor *)defaultLayout {
    MDLVertexDescriptor *vertexDescriptor = [MDLVertexDescriptor new];
    vertexDescriptor.attributes[0] = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributePosition
                                                                       format:MDLVertexFormatFloat3
                                                                       offset:0
                                                                  bufferIndex:0];
    vertexDescriptor.layouts[0] = [[MDLVertexBufferLayout alloc] initWithStride:sizeof(simd_float3)];
    
    return vertexDescriptor;
}

@end
