//
//  Model.m
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import "Model.h"
#import "MDLVertexDescriptor+DefaultLayout.h"
#import "TextureController.h"

@interface Model ()
@property (retain, nonatomic, readonly) NSArray<Mesh *> *meshes;
@property (copy, nonatomic, readonly) NSString *name;
@end

@implementation Model

- (instancetype)initWithName:(NSString *)name device:(id<MTLDevice>)device {
    if (self = [super init]) {
        NSURL *assetURL = [NSBundle.mainBundle URLForResource:name withExtension:nil];
        
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
        
        MDLAsset *asset = [[MDLAsset alloc] initWithURL:assetURL vertexDescriptor:MDLVertexDescriptor.defaultLayout bufferAllocator:allocator];
        [allocator release];
        
        [asset loadTextures];
        
        NSError * _Nullable error = nil;
        NSArray<MDLMesh *> *mdlMeshes;
        NSArray<MTKMesh *> *mtkMeshes = [MTKMesh newMeshesFromAsset:asset device:device sourceMeshes:&mdlMeshes error:&error];
        [asset release];
        assert(error == nil);
        
        NSMutableArray<Mesh *> *meshes = [[NSMutableArray alloc] initWithCapacity:mtkMeshes.count];
        [mtkMeshes enumerateObjectsUsingBlock:^(MTKMesh * _Nonnull mtkMesh, NSUInteger idx, BOOL * _Nonnull stop) {
            MDLMesh *mdlMesh = mdlMeshes[idx];
            Mesh *mesh = [[Mesh alloc] initWithMDLMesh:mdlMesh mtkMesh:mtkMesh device:device];
            [meshes addObject:mesh];
            [mesh release];
        }];
        [mtkMeshes release];
        
        _transform = [Transform new];
        _tiling = 1;
        _name = [name copy];
        _meshes = meshes;
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name primitive:(Primitive)primitive device:(id<MTLDevice>)device {
    if (self = [super init]) {
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
            default:
                abort();
                break;
        }
        
        [allocator release];
        
        mdlMesh.vertexDescriptor = MDLVertexDescriptor.defaultLayout;
        
        NSError * _Nullable error = nil;
        MTKMesh *mtkMesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
        assert(error == nil);
        
        Mesh *mesh = [[Mesh alloc] initWithMDLMesh:mdlMesh mtkMesh:mtkMesh device:device];
        [mdlMesh release];
        [mtkMesh release];
        
        _transform = [Transform new];
        _tiling = 1;
        _meshes = [[NSArray alloc] initWithObjects:mesh, nil];
        [mesh release];
        _name = [name copy];
    }
    
    return self;
}

- (void)dealloc {
    [_transform release];
    [_meshes release];
    [_name release];
    [super dealloc];
}

- (void)setTextureWithName:(NSString *)name type:(TextureIndices)type device:(id<MTLDevice>)device {
    id<MTLTexture> texture = [TextureController.sharedInstance loadTextureFromName:name device:device];
    
    switch (type) {
        case BaseColor:
            self.meshes[0].submeshes[0].textures.baseColor = texture;
            break;
        default:
            abort();
            break;
    }
}

- (void)renderInEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)vertex params:(Params)fragment {
    Uniforms uniforms = vertex;
    Params params = fragment;
    
    params.tiling = _tiling;
    uniforms.modelMatrix = _transform.modelMatrix;
    
    [encoder setVertexBytes:&uniforms length:sizeof(Uniforms) atIndex:UniformsBuffer];
    
    [encoder setFragmentBytes:&params length:sizeof(Params) atIndex:ParamsBuffer];
    
    for (Mesh *mesh in self.meshes) {
        [mesh.vertexBuffers enumerateObjectsUsingBlock:^(id<MTLBuffer>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [encoder setVertexBuffer:obj offset:0 atIndex:idx];
        }];
        
        for (Submesh *submesh in mesh.submeshes) {
            // set the fragment texture here
            
            [encoder setFragmentTexture:submesh.textures.baseColor atIndex:BaseColor];
            
            [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                                indexCount:submesh.indexCount
                                 indexType:submesh.indexType
                               indexBuffer:submesh.indexBuffer
                         indexBufferOffset:submesh.indexBufferOffset];
        }
    }
}

@end
