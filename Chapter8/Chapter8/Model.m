//
//  Model.m
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import "Model.h"
#import "Mesh.h"
#import "MTLVertexDescriptor+Category.h"

@interface Model ()
@property
@property (copy) NSString *name;
@end

@implementation Model

@synthesize transform = _transform;

- (instancetype)initWithName:(NSString *)name device:(id<MTLDevice>)device {
    if (self = [self init]) {
        NSURL *assetURL = [NSBundle.mainBundle URLForResource:name withExtension:nil];
        assert(assetURL);
        
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
        MDLAsset *asset = [[MDLAsset alloc] initWithURL:assetURL vertexDescriptor:MTLVertexDescriptor.defaultLayout bufferAllocator:allocator];
    }
    
    return self;
}

@end
