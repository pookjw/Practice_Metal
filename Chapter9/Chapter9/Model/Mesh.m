//
//  Mesh.m
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import "Mesh.h"

@implementation Mesh

- (instancetype)initWithMDLMesh:(MDLMesh *)mdlMesh mtkMesh:(MTKMesh *)mtkMesh device:(id<MTLDevice>)device {
    if (self = [super init]) {
        NSMutableArray<id<MTLBuffer>> *vertexBuffers = [[NSMutableArray alloc] initWithCapacity:mtkMesh.vertexCount];
        
        for (MTKMeshBuffer *mtkMeshBuffer in mtkMesh.vertexBuffers) {
            [vertexBuffers addObject:mtkMeshBuffer.buffer];
        }
        
        _vertexBuffers = vertexBuffers;
        
        //
        
        NSMutableArray<Submesh *> *submeshes = [[NSMutableArray alloc] initWithCapacity:mdlMesh.submeshes.count];
        [mdlMesh.submeshes enumerateObjectsUsingBlock:^(MDLSubmesh * _Nonnull mdlSubmesh, NSUInteger idx, BOOL * _Nonnull stop) {
            MTKSubmesh *mtkSubmesh = mtkMesh.submeshes[idx];
            Submesh *submesh = [[Submesh alloc] initWithMDLSubmesh:mdlSubmesh mtkSubmesh:mtkSubmesh device:device];
            [submeshes addObject:submesh];
            [submesh release];
        }];
        
        _submeshes = submeshes;
    }
    
    return self;
}

- (void)dealloc {
    [_vertexBuffers release];
    [_submeshes release];
    [super dealloc];
}

@end
