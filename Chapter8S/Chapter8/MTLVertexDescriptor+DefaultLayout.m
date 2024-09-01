//
//  MTLVertexDescriptor+DefaultLayout.m
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#import "MTLVertexDescriptor+DefaultLayout.h"
#import "Common.h"

@implementation MTLVertexDescriptor (DefaultLayout)

+ (MTLVertexDescriptor *)defaultLayout {
    return MTKMetalVertexDescriptorFromModelIO([MDLVertexDescriptor defaultLayout]);
}

@end

@implementation MDLVertexDescriptor (DefaultLayout)

+ (MDLVertexDescriptor *)defaultLayout {
    MDLVertexDescriptor *vertexDescriptor = [MDLVertexDescriptor new];
    
    NSUInteger offset = 0;
    
    //
    
    MDLVertexAttribute *positionVertexAttribute = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributePosition format:MDLVertexFormatFloat3 offset:offset bufferIndex:VertexBuffer];
    vertexDescriptor.attributes[Position] = positionVertexAttribute;
    [positionVertexAttribute release];
    
    offset += sizeof(simd_float3);
    
    MDLVertexAttribute *normalVertexAttribute = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeNormal format:MDLVertexFormatFloat3 offset:offset bufferIndex:VertexBuffer];
    vertexDescriptor.attributes[Normal] = normalVertexAttribute;
    [normalVertexAttribute release];
    
    offset += sizeof(simd_float3);
    
    MDLVertexBufferLayout *vertexBufferLayout = [[MDLVertexBufferLayout alloc] initWithStride:offset];
    vertexDescriptor.layouts[VertexBuffer] = vertexBufferLayout;
    [vertexBufferLayout release];
    
    offset = 0;
    
    //
    
    MDLVertexAttribute *uvVertexAttribute = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeTextureCoordinate format:MDLVertexFormatFloat2 offset:offset bufferIndex:UVBuffer];
    vertexDescriptor.attributes[UV] = uvVertexAttribute;
    [uvVertexAttribute release];
    
    offset += sizeof(simd_float2);
    
    MDLVertexBufferLayout *uvBufferLayout = [[MDLVertexBufferLayout alloc] initWithStride:offset];
    vertexDescriptor.layouts[UVBuffer] = uvBufferLayout;
    [uvBufferLayout release];
    
    //
    
    return [vertexDescriptor autorelease];
}

@end
