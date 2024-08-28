//
//  MTLVertexDescriptor+DefaultLayout.m
//  Chapter7
//
//  Created by Jinwoo Kim on 8/28/24.
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
    
    NSInteger offset = 0;
    
    //
    
    MDLVertexAttribute *vertexAttribute_0 = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributePosition format:MDLVertexFormatFloat3 offset:offset bufferIndex:VertexBuffer];
    vertexDescriptor.attributes[Position] = vertexAttribute_0;
    [vertexAttribute_0 release];
    
    offset += sizeof(simd_float3);
    
    //
    
    MDLVertexAttribute *vertexAttribute_1 = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeNormal format:MDLVertexFormatFloat3 offset:offset bufferIndex:VertexBuffer];
    vertexDescriptor.attributes[Normal] = vertexAttribute_1;
    [vertexAttribute_1 release];
    
    offset += sizeof(simd_float3);
    
    //
    
    MDLVertexBufferLayout *vertexBufferLayout = [[MDLVertexBufferLayout alloc] initWithStride:offset];
    vertexDescriptor.layouts[VertexBuffer] = vertexBufferLayout;
    [vertexBufferLayout release];
    
    return [vertexDescriptor autorelease];
}

@end
