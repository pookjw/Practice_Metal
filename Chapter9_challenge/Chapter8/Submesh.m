//
//  Submesh.m
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import "Submesh.h"
#import "TextureController.h"

@implementation SubmeshTextures

- (instancetype)initWithMaterial:(MDLMaterial *)material device:(id<MTLDevice>)device {
    if (self = [self init]) {
        self->_baseColor = [self propertyWithMaterial:material semantic:MDLMaterialSemanticBaseColor device:device];
    }
    
    return self;
}

- (id<MTLTexture> _Nullable)propertyWithMaterial:(MDLMaterial *)material semantic:(MDLMaterialSemantic)semantic device:(id<MTLDevice>)device {
    MDLMaterialProperty *property = [material propertyWithSemantic:semantic];
    if (property.type != MDLMaterialPropertyTypeString) return nil;
    
    NSString *filename = property.stringValue;
    if (!filename) return nil;
    
    id<MTLTexture> texture = [TextureController textureFromFilename:filename device:device];
    return texture;
}

@end

@implementation Submesh

- (instancetype)initWithMDLSubmesh:(MDLSubmesh *)mdlSubMesh mtkSubmesh:(MTKSubmesh *)mtkSubmesh device:(id<MTLDevice>)device {
    if (self = [self init]) {
        _indexCount = mtkSubmesh.indexCount;
        _indexType = mtkSubmesh.indexType;
        _indexBuffer = mtkSubmesh.indexBuffer.buffer;
        _indexBufferOffset = mtkSubmesh.indexBuffer.offset;
        _textures = [[SubmeshTextures alloc] initWithMaterial:mdlSubMesh.material device:device];
    }
    
    return self;
}

@end
