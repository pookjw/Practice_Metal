//
//  Mesh.m
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#import "Mesh.h"

@implementation Mesh

- (instancetype)initWithMDLMesh:(MDLMesh *)mdlMesh mtkMesh:(MTKMesh *)mtkMesh device:(id<MTLDevice>)device {
    if (self = [super init]) {
        NSMutableArray<id<MTLBuffer>> *vertexBuffers = [[NSMutableArray alloc] initWithCapacity:mtkMesh.vertexBuffers.count];
        
        for (MTKMeshBuffer *mtkMeshBuffer in mtkMesh.vertexBuffers) {
            [vertexBuffers addObject:mtkMeshBuffer.buffer];
        }
        
        _vertexBuffers = [vertexBuffers retain];
        [vertexBuffers release];
        
        //
        
        NSMutableArray<Submesh *> *submeshes = [[NSMutableArray alloc] initWithCapacity:mdlMesh.submeshes.count];
        [mdlMesh.submeshes enumerateObjectsUsingBlock:^(MDLSubmesh * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Submesh *submesh = [[Submesh alloc] initWithMDLSubmesh:obj mtkSubmesh:mtkMesh.submeshes[idx] device:device];
            [submeshes addObject:submesh];
            [submesh release];
        }];
        
        _submeshes = [submeshes retain];
        [submeshes release];
    }
    
    return self;
}

- (void)dealloc {
    [_vertexBuffers release];
    [_submeshes release];
    [super dealloc];
}

@end
