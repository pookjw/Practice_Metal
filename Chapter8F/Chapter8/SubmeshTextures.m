//
//  SubmeshTextures.m
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#import "SubmeshTextures.h"
#import "TextureController.h"

@implementation SubmeshTextures

- (instancetype)initWithMaterial:(MDLMaterial *)material device:(id<MTLDevice>)device {
    if (self = [super init]) {
        _baseColor = [[self textureFromMaterial:material semantic:MDLMaterialSemanticBaseColor device:device] retain];
    }
    
    return self;
}

- (void)dealloc {
    [_baseColor release];
    [super dealloc];
}

- (id<MTLTexture> _Nullable)textureFromMaterial:(MDLMaterial *)material semantic:(MDLMaterialSemantic)semantic device:(id<MTLDevice>)device {
    MDLMaterialProperty * _Nullable property = [material propertyWithSemantic:semantic];
    
    if (property == nil) return nil;
    if (property.type != MDLMaterialPropertyTypeTexture) return nil;
    
    MDLTexture *mdlTexture = property.textureSamplerValue.texture;
    
    return [TextureController.sharedInstance loadTexture:mdlTexture device:device name:property.stringValue];
}

@end
