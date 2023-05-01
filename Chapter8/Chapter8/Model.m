//
//  Model.m
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import "Model.h"
#import "Mesh.h"
#import "MDLVertexDescriptor+Category.h"

@interface Model ()
@property (copy) NSString *name;
@property (strong) NSArray<Mesh *> *meshes;
@end

@implementation Model

@synthesize transform = _transform;

- (instancetype)initWithName:(NSString *)name device:(id<MTLDevice>)device {
    if (self = [self init]) {
        NSURL *assetURL = [NSBundle.mainBundle URLForResource:name withExtension:nil];
        assert(assetURL);
        
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
        MDLAsset *asset = [[MDLAsset alloc] initWithURL:assetURL vertexDescriptor:MDLVertexDescriptor.defaultLayout bufferAllocator:allocator];
        
        NSError * _Nullable error = nil;
        
        NSArray<MDLMesh *> *mdlMeshes = nil;
        NSArray<MTKMesh *> *mtkMeshes = [MTKMesh newMeshesFromAsset:asset device:device sourceMeshes:&mdlMeshes error:&error];
        
        NSMutableArray<Mesh *> *meshes = [NSMutableArray new];
        [mtkMeshes enumerateObjectsUsingBlock:^(MTKMesh * _Nonnull mtkMesh, NSUInteger idx, BOOL * _Nonnull stop) {
            [meshes addObject:[[Mesh alloc] initWithMDLMesh:mdlMeshes[idx] mtkMesh:mtkMesh]];
        }];
        
        self.name = name;
        self.meshes = meshes;
        self->_transform = [Transform new];
    }
    
    return self;
}

- (void)renderInEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)uniforms params:(Params)params {
    uniforms.modelMatrix = self.transform.modelMatrix;
    
    [encoder setVertexBytes:&uniforms length:sizeof(Uniforms) atIndex:UniformsBuffer];
    
    [encoder setFragmentBytes:&params length:sizeof(Params) atIndex:ParamsBuffer];
    
    [self.meshes enumerateObjectsUsingBlock:^(Mesh * _Nonnull mesh, NSUInteger idx, BOOL * _Nonnull stop) {
        [mesh.vertexBuffers enumerateObjectsUsingBlock:^(id<MTLBuffer>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [encoder setVertexBuffer:obj offset:0 atIndex:idx];
        }];
        
        [mesh.submeshes enumerateObjectsUsingBlock:^(Submesh * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                                indexCount:obj.indexCount
                                 indexType:obj.indexType
                               indexBuffer:obj.indexBuffer
                         indexBufferOffset:obj.indexBufferOffset];
        }];
    }];
}

@end
