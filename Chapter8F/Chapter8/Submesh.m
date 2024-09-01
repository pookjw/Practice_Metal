//
//  Submesh.m
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#import "Submesh.h"

@implementation Submesh

- (instancetype)initWithMDLSubmesh:(MDLSubmesh *)mdlSubmesh mtkSubmesh:(MTKSubmesh *)mtkSubmesh device:(id<MTLDevice>)device {
    if (self = [super init]) {
        _indexCount = mtkSubmesh.indexCount;
        _indexType = mtkSubmesh.indexType;
        _indexBuffer = [mtkSubmesh.indexBuffer.buffer retain];
        _indexBufferOffset = mtkSubmesh.indexBuffer.offset;
        
        SubmeshTextures *textures = [[SubmeshTextures alloc] initWithMaterial:mdlSubmesh.material device:device];
        _textures = [textures retain];
        [textures release];
    }
    
    return self;
}

- (void)dealloc {
    [_indexBuffer release];
    [_textures release];
    [super dealloc];
}

@end
