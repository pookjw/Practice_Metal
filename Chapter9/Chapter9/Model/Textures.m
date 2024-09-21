//
//  Textures.m
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import "Textures.h"
#import "TextureController.h"

@implementation Textures

- (instancetype)initWithMaterial:(MDLMaterial *)material device:(id<MTLDevice>)device {
    if (self = [super init]) {
        MDLMaterialProperty * _Nullable property = [material propertyWithSemantic:MDLMaterialSemanticBaseColor];
        if (property == nil) {
            return self;
        }
        
        if (property.type != MDLMaterialPropertyTypeTexture) {
            return self;
        }
        
        MDLTexture *mdlTexture = property.textureSamplerValue.texture;
        
        _baseColor = [[TextureController.sharedInstance loadTextureFromTexture:mdlTexture name:property.stringValue device:device] retain];
    }
    
    return self;
}

- (void)dealloc {
    [_baseColor release];
    [super dealloc];
}

@end
