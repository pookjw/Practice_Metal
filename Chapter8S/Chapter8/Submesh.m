//
//  Submesh.m
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#import "Submesh.h"

@implementation Submesh

- (instancetype)initWithMDLSubmesh:(MDLSubmesh *)mdlSubmesh mtkSubmesh:(MTKSubmesh *)mtkSubmesh {
    if (self = [super init]) {
        _indexCount = mtkSubmesh.indexCount;
        _indexType = mtkSubmesh.indexType;
        _indexBuffer = [mtkSubmesh.indexBuffer.buffer retain];
        _indexBufferOffset = mtkSubmesh.indexBuffer.offset;
    }
    
    return self;
}

- (void)dealloc {
    [_indexBuffer release];
    [super dealloc];
}

@end
