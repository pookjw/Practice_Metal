//
//  Model.m
//  Project6
//
//  Created by Jinwoo Kim on 4/13/23.
//

#import "Model.h"
#import "MDLVertexDescriptor+Category.h"

@interface Model ()
@property (strong) MTKMesh *mesh;
@property (strong) NSString *name;
@end

@implementation Model

@synthesize transform = _transform;

- (instancetype)initWithDevice:(id<MTLDevice>)device name:(NSString *)name {
    if (self = [self init]) {
        NSURL * _Nullable assetURL = [NSBundle.mainBundle URLForResource:name withExtension:nil];
        assert(assetURL);
        
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
        MDLAsset *asset = [[MDLAsset alloc] initWithURL:assetURL vertexDescriptor:MDLVertexDescriptor.defaultLayout bufferAllocator:allocator];
        MDLMesh *mdlMesh = (MDLMesh *)[asset childObjectsOfClass:MDLMesh.class].firstObject;
        NSError * _Nullable error = nil;
        MTKMesh *mtkMesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
        NSAssert((error == nil), error.localizedDescription);
        
        Transform *transform = [Transform new];
        
        self.name = name;
        self.mesh = mtkMesh;
        self->_transform = transform;
    }
    
    return self;
}

- (void)renderWithEncoder:(id<MTLRenderCommandEncoder>)encoder {
    [encoder setVertexBuffer:self.mesh.vertexBuffers[0].buffer
                      offset:0 
                     atIndex:0];
    
    [self.mesh.submeshes enumerateObjectsUsingBlock:^(MTKSubmesh * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                            indexCount:obj.indexCount
                             indexType:obj.indexType
                           indexBuffer:obj.indexBuffer.buffer
                     indexBufferOffset:obj.indexBuffer.offset];
    }];
}

@end
