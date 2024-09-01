//
//  Model.m
//  Chapter6
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import "Model.h"
#import "MTLVertexDescriptor+DefaultLayout.h"
#import "Mesh.h"
#import "TextureController.h"

@interface Model ()
@property (retain, readonly, nonatomic) NSArray<Mesh *> *meshes;
@property (copy, readonly, nonatomic) NSString *name;
@end

@implementation Model

+ (MDLMesh *)createMeshWithPrimitive:(Primitive)primitive device:(id<MTLDevice>)device {
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    
    MDLMesh *mdlMesh;
    switch (primitive) {
        case PrimitivePlane:
            mdlMesh = [[MDLMesh alloc] initPlaneWithExtent:simd_make_float3(1.f, 1.f, 1.f)
                                                  segments:simd_make_uint2(4, 4)
                                              geometryType:MDLGeometryTypeTriangles
                                                 allocator:allocator];
            break;
        case PrimitiveSphere:
            mdlMesh = [[MDLMesh alloc] initSphereWithExtent:simd_make_float3(1.f, 1.f, 1.f)
                                                   segments:simd_make_uint2(30, 30)
                                              inwardNormals:NO
                                               geometryType:MDLGeometryTypeTriangles
                                                  allocator:allocator];
            break;
    }
    
    [allocator release];
    return [mdlMesh autorelease];
}

- (instancetype)initWithDevice:(id<MTLDevice>)device name:(NSString *)name {
    if (self = [super init]) {
        NSURL *assetURL = [NSBundle.mainBundle URLForResource:name withExtension:nil];
        
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
        MDLAsset *asset = [[MDLAsset alloc] initWithURL:assetURL
                                       vertexDescriptor:[MDLVertexDescriptor defaultLayout]
                                        bufferAllocator:allocator];
        [allocator release];
        
        [asset loadTextures];
        
        NSError * _Nullable error = nil;
        NSArray<MDLMesh *> *mdlMeshes;
        NSArray<MTKMesh *> *mtkMeshes = [MTKMesh newMeshesFromAsset:asset device:device sourceMeshes:&mdlMeshes error:&error];
        [asset release];
        assert(error == nil);
        
        NSMutableArray<Mesh *> *meshes = [[NSMutableArray alloc] initWithCapacity:mdlMeshes.count];
        [mdlMeshes enumerateObjectsUsingBlock:^(MDLMesh * _Nonnull mdlMesh, NSUInteger idx, BOOL * _Nonnull stop) {
            MTKMesh *mtkMesh = mtkMeshes[idx];
            Mesh *mesh = [[Mesh alloc] initWithMDLMesh:mdlMesh mtkMesh:mtkMesh device:device];
            [meshes addObject:mesh];
            [mesh release];
        }];
        
        Transform *transform = [Transform new];
        
        _transform = [transform retain];
        _meshes = [meshes retain];
        _name = [name copy];
        [transform release];
        [meshes release];
        _tiling = 1;
    }
    
    return self;
}

- (instancetype)initWithDevice:(id<MTLDevice>)device name:(NSString *)name primitive:(Primitive)primitive {
    if (self = [super init]) {
        MDLMesh *mdlMesh = [Model createMeshWithPrimitive:primitive device:device];
        mdlMesh.vertexDescriptor = [MDLVertexDescriptor defaultLayout];
        
        NSError * _Nullable error = nil;
        MTKMesh *mtkMesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
        assert(error == nil);
        
        Mesh *mesh = [[Mesh alloc] initWithMDLMesh:mdlMesh mtkMesh:mtkMesh device:device];
        [mtkMesh release];
        
        Transform *transform = [Transform new];
        
        _transform = [transform retain];
        _meshes = [@[mesh] retain];
        _name = [name copy];
        [mesh release];
        _tiling = 1;
    }
    
    return self;
}

- (void)dealloc {
    [_transform release];
    [_meshes release];
    [_name release];
    [super dealloc];
}

- (void)renderInEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)uniforms params:(Params)params {
    uniforms.modelMatrix = _transform.modelMatrix;
    params.tiling = _tiling;
    
    [encoder setVertexBytes:&uniforms length:sizeof(Uniforms) atIndex:UniformsBuffer];
    
    [encoder setFragmentBytes:&params length:sizeof(Params) atIndex:ParamsBuffer];
    
    for (Mesh *mesh in self.meshes) {
        [mesh.vertexBuffers enumerateObjectsUsingBlock:^(id<MTLBuffer>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [encoder setVertexBuffer:obj offset:0 atIndex:idx];
        }];
        
        for (Submesh *submesh in mesh.submeshes) {
            [encoder setFragmentTexture:submesh.textures.baseColor atIndex:BaseColor];
            
            [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:submesh.indexCount indexType:submesh.indexType indexBuffer:submesh.indexBuffer indexBufferOffset:submesh.indexBufferOffset];
        }
    }
}

- (void)setTextureWithName:(NSString *)name type:(TextureIndices)type device:(id<MTLDevice>)device {
    id<MTLTexture> texture = [TextureController.sharedInstance loadTextureWithName:name device:device];
    assert(texture != nil);
    
    self.meshes[0].submeshes[0].textures.baseColor = texture;
}

@end
