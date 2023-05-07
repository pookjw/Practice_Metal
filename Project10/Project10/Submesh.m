//
//  Submesh.m
//  Project10
//
//  Created by Jinwoo Kim on 5/8/23.
//

#import "Submesh.h"
#import "TextureController.h"

@implementation Textures

- (instancetype)initWithMaterial:(MDLMaterial *)material device:(id<MTLDevice>)device {
    if (self = [self init]) {
        self->_baseColor = [self propertyWithMaterial:material semantic:MDLMaterialSemanticBaseColor device:device];
    }
    
    return self;
}

- (id<MTLTexture> _Nullable)propertyWithMaterial:(MDLMaterial *)material semantic:(MDLMaterialSemantic)semantic device:(id<MTLDevice>)device {
    MDLMaterialProperty *property = [material propertyWithSemantic:semantic];
    assert(property);
    assert(property.type == MDLMaterialPropertyTypeString);
    
    NSString *filename = property.stringValue;
    id<MTLTexture> texture = [TextureController textureFromFilename:filename device:device];
    assert(texture);
    
    return texture;
}

@end

@implementation Submesh

- (instancetype)initWithMDLSubMesh:(MDLSubmesh *)mdlSubmesh mtkSubmesh:(MTKSubmesh *)mtkSubmesh device:(id<MTLDevice>)device {
    if (self = [self init]) {
        _indexCount = mtkSubmesh.indexCount;
        _indexType = mtkSubmesh.indexType;
        _indexBuffer = mtkSubmesh.indexBuffer.buffer;
        _indexBufferOffset = mtkSubmesh.indexBuffer.offset;
        _textures = [[Textures alloc] initWithMaterial:mdlSubmesh.material device:device];
    }
    
    return self;
}

@end
