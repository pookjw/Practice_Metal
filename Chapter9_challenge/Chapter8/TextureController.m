//
//  TextureController.m
//  Chapter8
//
//  Created by Jinwoo Kim on 5/1/23.
//

#import "TextureController.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

static NSDictionary<NSString *, id<MTLTexture>> *kTextures = @{};

@interface TextureController ()
@property (class) NSDictionary<NSString *, id<MTLTexture>> *textures;
@end

@implementation TextureController

+ (NSDictionary<NSString *,id<MTLTexture>> *)textures {
    return kTextures;
}

+ (void)setTextures:(NSDictionary<NSString *,id<MTLTexture>> *)textures {
    kTextures = textures;
}

+ (id<MTLTexture> _Nullable)textureFromFilename:(NSString *)filename device:(id<MTLDevice>)device {
    if (self.textures[filename]) {
        return self.textures[filename];
    }
    
    NSError * _Nullable error = nil;
    id<MTLTexture> _Nullable texture = [self loadTextureFromFilename:filename devide:device error:&error];
    NSAssert((error == nil), error.localizedDescription);
    
    if (texture) {
        NSMutableDictionary *m = [self.textures mutableCopy];
        m[filename] = texture;
        self.textures = [m copy];
    }
    
    return texture;
}

+ (id<MTLTexture> _Nullable)loadTextureFromFilename:(NSString *)filename devide:(id<MTLDevice>)device error:(NSError * __autoreleasing * _Nullable)error {
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    
    // Load from Textures.xcassets
    id<MTLTexture> _Nullable _xcTexture = [textureLoader newTextureWithName:filename
                                                                scaleFactor:1.f
                                                                     bundle:NSBundle.mainBundle
                                                                    options:0
                                                                      error:nil];
    if (_xcTexture) {
        return _xcTexture;
    }
    
    NSURL *url = [NSBundle.mainBundle URLForResource:filename withExtension:nil];
    
    NSDictionary <MTKTextureLoaderOption, id> *options = @{
        MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft,
        MTKTextureLoaderOptionSRGB: @NO, // NO -> bgra8Unorm
        MTKTextureLoaderOptionGenerateMipmaps: @YES
    };
    
    id<MTLTexture> texture = [textureLoader newTextureWithContentsOfURL:url options:options error:error];
    return texture;
}

@end
