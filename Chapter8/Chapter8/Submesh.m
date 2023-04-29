//
//  Submesh.m
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import "Submesh.h"

@implementation Submesh

- (instancetype)initWithMDLSubmesh:(MDLSubmesh *)mdlSubMesh mtkSubmesh:(MTKSubmesh *)mtkSubmesh {
    if (self = [self init]) {
        _indexCount = mtkSubmesh.indexCount;
        _indexType = mtkSubmesh.indexType;
        _indexBuffer = mtkSubmesh.indexBuffer.buffer;
        _indexBufferOffset = mtkSubmesh.indexBuffer.offset;
    }
    
    return self;
}

@end
