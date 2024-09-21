//
//  Submesh.m
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import "Submesh.h"

@implementation Submesh

- (instancetype)initWithMDLSubmesh:(MDLSubmesh *)mdlSubmesh mtkSubmesh:(MTKSubmesh *)mtkSubmesh device:(id<MTLDevice>)device {
    if (self = [super init]) {
        _indexCount = mtkSubmesh.indexCount;
        _indexType = mtkSubmesh.indexType;
        _indexBuffer = mtkSubmesh.indexBuffer.buffer;
        _indexBufferOffset = mtkSubmesh.indexBuffer.offset;
        _textures = [[Textures alloc] initWithMaterial:mdlSubmesh.material device:device];
    }
    
    return self;
}

- (void)dealloc {
    [_textures release];
    [_indexBuffer release];
    [super dealloc];
}

@end
