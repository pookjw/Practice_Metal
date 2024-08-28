//
//  MTLVertexDescriptor+DefaultLayout.m
//  Chapter7
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import "MTLVertexDescriptor+DefaultLayout.h"

@implementation MTLVertexDescriptor (DefaultLayout)

+ (MTLVertexDescriptor *)defaultLayout {
    return MTKMetalVertexDescriptorFromModelIO([MDLVertexDescriptor defaultLayout]);
}

@end

@implementation MDLVertexDescriptor (DefaultLayout)

+ (MDLVertexDescriptor *)defaultLayout {
    MDLVertexDescriptor *vertexDescriptor = [MDLVertexDescriptor new];
    
    NSInteger offset = 0;
    
    MDLVertexAttribute *vertexAttribute = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributePosition format:MDLVertexFormatFloat3 offset:0 bufferIndex:0];
    vertexDescriptor.attributes[0] = vertexAttribute;
    [vertexAttribute release];
    
    offset += sizeof(simd_float3);
    
    MDLVertexBufferLayout *vertexBufferLayout = [[MDLVertexBufferLayout alloc] initWithStride:offset];
    vertexDescriptor.layouts[0] = vertexBufferLayout;
    [vertexBufferLayout release];
    
    return [vertexDescriptor autorelease];
}

@end
