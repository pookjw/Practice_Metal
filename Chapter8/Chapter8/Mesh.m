//
//  Mesh.m
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import "Mesh.h"

@implementation Mesh

- (instancetype)initWithMDLMesh:(MDLMesh *)mdlMesh mtkMesh:(MTKMesh *)mtkMesh {
    if (self = [self init]) {
        NSMutableArray<id<MTLBuffer>> *vertexBuffers = [NSMutableArray new];
        [mtkMesh.vertexBuffers enumerateObjectsUsingBlock:^(MTKMeshBuffer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [vertexBuffers addObject:obj.buffer];
        }];
        
        self->_vertexBuffers = vertexBuffers;
        
        NSMutableArray<Submesh *> *submeshes = [NSMutableArray new];
        [mdlMesh.submeshes enumerateObjectsUsingBlock:^(MDLSubmesh * _Nonnull mdlSubMesh, NSUInteger idx, BOOL * _Nonnull stop) {
            MTKSubmesh *mtkSubmesh = mtkMesh.submeshes[idx];
            
            [submeshes addObject:[[Submesh alloc] initWithMDLSubmesh:mdlSubMesh mtkSubmesh:mtkSubmesh]];
        }];
        
        self->_submeshes = submeshes;
    }
    
    return self;
}

@end
