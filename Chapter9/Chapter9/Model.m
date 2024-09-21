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
        _meshes = meshes;
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
            break;
    }
}

- (void)renderInEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)vertex params:(Params)fragment {
    abort();
}

@end
