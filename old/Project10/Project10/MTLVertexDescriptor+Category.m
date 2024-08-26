//
//  MTLVertexDescriptor+Category.m
//  Project10
//
//  Created by Jinwoo Kim on 5/8/23.
//

#import "MTLVertexDescriptor+Category.h"
#import "MDLVertexDescriptor+Category.h"

@implementation MTLVertexDescriptor (Category)

+ (MTLVertexDescriptor *)defaultLayout {
    NSError * _Nullable error = nil;
    MTLVertexDescriptor *defaultLayoyt = MTKMetalVertexDescriptorFromModelIOWithError(MDLVertexDescriptor.defaultLayout, &error);
    NSAssert(!error, error.localizedDescription);
    return defaultLayoyt;
}

@end
