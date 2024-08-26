//
//  Model.m
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import "Model.h"
#import "Mesh.h"
#import "MDLVertexDescriptor+Category.h"
#import "MathLibrary.h"

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
        NSArray<MDLMesh *> * _Nullable mdlMeshes = nil;
        NSArray<MTKMesh *> * _Nullable mtkMeshes = [MTKMesh newMeshesFromAsset:asset device:device sourceMeshes:&mdlMeshes error:&error];
        NSAssert(!error, error.localizedDescription);
        
        NSMutableArray<Mesh *> *meshes = [NSMutableArray new];
        [mdlMeshes enumerateObjectsUsingBlock:^(MDLMesh * _Nonnull mdlMesh, NSUInteger idx, BOOL * _Nonnull stop) {
            MTKMesh *mtkMesh = mtkMeshes[idx];
            [meshes addObject:[[Mesh alloc] initWithMDLMesh:mdlMesh mtkMesh:mtkMesh device:device]];
        }];
        
        self->_transform = [Transform new];
        self.tiling = 1.f;
        self.name = name;
        self.meshes = meshes;
    }
    
    return self;
}

- (void)renderInEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)vertex params:(Params)fragment {
    Uniforms uniforms = vertex;
    uniforms.modelMatrix = self.transform.modelMatrix;
    uniforms.normalMatrix = [MathLibrary upperLeftFloat3x3FromFloat4x4:uniforms.modelMatrix];
    
    Params params = fragment;
    params.tiling = self.tiling;
    
    [encoder setVertexBytes:&uniforms length:sizeof(Uniforms) atIndex:UniformsBuffer];
    [encoder setFragmentBytes:&params length:sizeof(Params) atIndex:ParamsBuffer];
    
    [self.meshes enumerateObjectsUsingBlock:^(Mesh * _Nonnull mesh, NSUInteger idx, BOOL * _Nonnull stop) {
        [mesh.vertexBuffers enumerateObjectsUsingBlock:^(id<MTLBuffer>  _Nonnull vertexBuffer, NSUInteger idx, BOOL * _Nonnull stop) {
            [encoder setVertexBuffer:vertexBuffer offset:0 atIndex:idx];
        }];
        
        [mesh.submeshes enumerateObjectsUsingBlock:^(Submesh * _Nonnull submesh, NSUInteger idx, BOOL * _Nonnull stop) {
            [encoder setFragmentTexture:submesh.textures.baseColor atIndex:BaseColor];
            
            [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                                indexCount:submesh.indexCount
                                 indexType:submesh.indexType
                               indexBuffer:submesh.indexBuffer
                         indexBufferOffset:submesh.indexBufferOffset];
        }];
    }];
}

@end
