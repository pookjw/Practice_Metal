//
//  MTLVertexDescriptor+DefaultLayout.m
//  Chapter5
//
//  Created by Jinwoo Kim on 8/27/24.
//

#import "MTLVertexDescriptor+DefaultLayout.h"
#import "Triangle.h"

@implementation MTLVertexDescriptor (DefaultLayout)

+ (MTLVertexDescriptor *)defaultLayout {
    MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor new];
    
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    vertexDescriptor.layouts[0].stride = sizeof(Vertex);
    
    return [vertexDescriptor autorelease];
}

@end
