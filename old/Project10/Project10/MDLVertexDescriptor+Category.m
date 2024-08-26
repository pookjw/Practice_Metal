//
//  MDLVertexDescriptor+Category.m
//  Project10
//
//  Created by Jinwoo Kim on 5/7/23.
//

#import "MDLVertexDescriptor+Category.h"
#import "common.h"

@implementation MDLVertexDescriptor (Category)

+ (MDLVertexDescriptor *)defaultLayout {
    MDLVertexDescriptor *vertexDescriptor = [MDLVertexDescriptor new];
    
    NSUInteger offet = 0;
    
    vertexDescriptor.attributes[Position] = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributePosition format:MDLVertexFormatFloat3 offset:offet bufferIndex:VertexBuffer];
    
    offet += sizeof(simd_float3);
    
    vertexDescriptor.attributes[Normal] = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeNormal format:MDLVertexFormatFloat3 offset:offet bufferIndex:VertexBuffer];
    
    offet += sizeof(simd_float3);
    
    vertexDescriptor.layouts[VertexBuffer] = [[MDLVertexBufferLayout alloc] initWithStride:offet];
    
    vertexDescriptor.attributes[UV] = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeTextureCoordinate format:MDLVertexFormatFloat2 offset:0 bufferIndex:UVBuffer];
    
    vertexDescriptor.layouts[UVBuffer] = [[MDLVertexBufferLayout alloc] initWithStride:sizeof(simd_float2)];
    
    vertexDescriptor.attributes[Color] = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeColor format:MDLVertexFormatFloat3 offset:0 bufferIndex:ColorBuffer];
    
    vertexDescriptor.layouts[ColorBuffer] = [[MDLVertexBufferLayout alloc] initWithStride:sizeof(simd_float3)];
    
    return vertexDescriptor;
}

@end
