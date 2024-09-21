//
//  MDLVertexDescriptor+DefaultLayout.m
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import "MDLVertexDescriptor+DefaultLayout.h"
#import "Common.h"

@implementation MDLVertexDescriptor (DefaultLayout)

+ (MDLVertexDescriptor *)defaultLayout {
    MDLVertexDescriptor *vertexDescriptor = [MDLVertexDescriptor new];
    
    NSUInteger offset = 0;
    
    //
    
    MDLVertexAttribute *positionAttribute = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributePosition format:MDLVertexFormatFloat3 offset:offset bufferIndex:VertexBuffer];
    vertexDescriptor.attributes[Position] = positionAttribute;
    [positionAttribute release];
    offset += sizeof(simd_float3);
    
    MDLVertexAttribute *normalAttribute = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeNormal format:MDLVertexFormatFloat3 offset:offset bufferIndex:VertexBuffer];
    vertexDescriptor.attributes[Normal] = normalAttribute;
    [normalAttribute release];
    offset += sizeof(simd_float3);
    
    MDLVertexBufferLayout *vertexBufferLayout = [[MDLVertexBufferLayout alloc] initWithStride:offset];
    vertexDescriptor.layouts[VertexBuffer] = vertexBufferLayout;
    [vertexBufferLayout release];
    offset = 0;
    
    //
    
    MDLVertexAttribute *uvAttribute = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeTextureCoordinate format:MDLVertexFormatFloat2 offset:offset bufferIndex:UVBuffer];
    offset += sizeof(simd_float2);
    vertexDescriptor.attributes[UV] = uvAttribute;
    [uvAttribute release];
    offset += sizeof(simd_float2);
    
    MDLVertexBufferLayout *uvBufferLayout = [[MDLVertexBufferLayout alloc] initWithStride:offset];
    vertexDescriptor.layouts[UVBuffer] = uvBufferLayout;
    [uvBufferLayout release];
    
    return [vertexDescriptor autorelease];
}

@end
