//
//  Model.m
//  Chapter6
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import "Model.h"
#import "MTLVertexDescriptor+DefaultLayout.h"

@interface Model ()
@property (retain, readonly, nonatomic) MTKMesh *mesh;
@property (copy, readonly, nonatomic) NSString *name;
@end

@implementation Model

- (instancetype)initWithDevice:(id<MTLDevice>)device name:(NSString *)name {
    if (self = [super init]) {
        NSURL *assetURL = [NSBundle.mainBundle URLForResource:name withExtension:nil];
        
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
        MDLAsset *asset = [[MDLAsset alloc] initWithURL:assetURL
                                       vertexDescriptor:[MDLVertexDescriptor defaultLayout]
                                        bufferAllocator:allocator];
        [allocator release];
        
        MDLMesh *mdlMesh = (MDLMesh *)[asset childObjectsOfClass:MDLMesh.class][0];
        [asset release];
        
        NSError * _Nullable error = nil;
        MTKMesh *mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
        assert(error == nil);
        
        _mesh = [mesh retain];
        _name = [name copy];
        [mesh release];
    }
    
    return self;
}

- (void)dealloc {
    [_mesh release];
    [_name release];
    [super dealloc];
}

- (void)renderInEncoder:(id<MTLRenderCommandEncoder>)encoder {
    [encoder setVertexBuffer:self.mesh.vertexBuffers[0].buffer offset:0 atIndex:0];
    
    for (MTKSubmesh *submesh in self.mesh.submeshes) {
        [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                            indexCount:submesh.indexCount
                             indexType:submesh.indexType
                           indexBuffer:submesh.indexBuffer.buffer
                     indexBufferOffset:submesh.indexBuffer.offset];
    }
}

@end
