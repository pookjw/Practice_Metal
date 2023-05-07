//
//  Mesh.m
//  Project10
//
//  Created by Jinwoo Kim on 5/8/23.
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
        
        // TODO
    }
    
    return self;
}

@end
