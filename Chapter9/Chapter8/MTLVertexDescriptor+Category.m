//
//  MTLVertexDescriptor+Category.m
//  Chapter8
//
//  Created by Jinwoo Kim on 5/1/23.
//

#import "MTLVertexDescriptor+Category.h"
#import "MDLVertexDescriptor+Category.h"

@implementation MTLVertexDescriptor (Category)

+ (MTLVertexDescriptor *)defaultLayout {
    return MTKMetalVertexDescriptorFromModelIO(MDLVertexDescriptor.defaultLayout);
}

@end
