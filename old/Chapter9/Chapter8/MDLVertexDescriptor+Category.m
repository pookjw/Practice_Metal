//
//  MDLVertexDescriptor+Category.m
//  Chapter8
//
//  Created by Jinwoo Kim on 5/1/23.
//

#import "MDLVertexDescriptor+Category.h"
#import "Common.h"

@implementation MDLVertexDescriptor (Category)

+ (MDLVertexDescriptor *)defaultLayout {
    MDLVertexDescriptor *vertexDescriptor = [MDLVertexDescriptor new];
    NSUInteger offset = 0;
    
    vertexDescriptor.attributes[Position] =
    [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributePosition format:MDLVertexFormatFloat3 offset:offset bufferIndex:VertexBuffer];
    
    offset += sizeof(simd_float3);
    
    vertexDescriptor.attributes[Normal] = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeNormal format:MDLVertexFormatFloat3 offset:offset bufferIndex:VertexBuffer];
    
    offset += sizeof(simd_float3);
    
    vertexDescriptor.layouts[VertexBuffer] = [[MDLVertexBufferLayout alloc] initWithStride:offset];
    
    vertexDescriptor.attributes[UV] = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeTextureCoordinate format:MDLVertexFormatFloat2 offset:0 bufferIndex:UVBuffer];
    
    vertexDescriptor.layouts[UVBuffer] = [[MDLVertexBufferLayout alloc] initWithStride:sizeof(simd_float2)];
    
    return vertexDescriptor;
}

@end
