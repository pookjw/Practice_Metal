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
        MDLMaterialProperty *property = [material propertyWithSemantic:MDLMaterialSemanticBaseColor];
        assert(property != nil);
        assert(property.type == MDLMaterialPropertyTypeTexture);
        
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
