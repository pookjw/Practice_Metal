//
//  MTLVertexDescriptor+DefaultLayout.m
//  Chapter6
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
    
    NSUInteger offset = 0;
    
    MDLVertexAttribute *attribute = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributePosition format:MDLVertexFormatFloat3
                                                                      offset:0
                                                                 bufferIndex:0];
    vertexDescriptor.attributes[0] = attribute;
    [attribute release];
    
    offset += sizeof(simd_float3);
    MDLVertexBufferLayout *layout = [[MDLVertexBufferLayout alloc] initWithStride:offset];
    vertexDescriptor.layouts[0] = layout;
    [layout release];
    
    return [vertexDescriptor autorelease];
}

@end
