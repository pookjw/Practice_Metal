//
//  TextureController.m
//  Project10
//
//  Created by Jinwoo Kim on 5/8/23.
//

#import "TextureController.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

static NSMutableDictionary<NSString *, id<MTLTexture>> *kTextures = nil;

@implementation TextureController

+ (id<MTLTexture> _Nullable)textureFromFilename:(NSString *)filename device:(id<MTLDevice>)device {
    id<MTLTexture> _texture = kTextures[filename];
    if (_texture) return _texture;
    
    id<MTLTexture> texture = [self loadTextureFromFilename:filename device:device];
    
    if (!texture) return nil;
    if (!kTextures) {
        kTextures = [NSMutableDictionary new];
    }
    
    kTextures[filename] = texture;
    return texture;
}

+ (id<MTLTexture> _Nullable)loadTextureFromFilename:(NSString *)filename device:(id<MTLDevice>)device {
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    
    NSError * _Nullable error = nil;
    id<MTLTexture> _Nullable _texture = [textureLoader newTextureWithName:filename scaleFactor:1.f bundle:NSBundle.mainBundle options:nil error:&error];
    NSAssert(!error, error.localizedDescription);
    if (_texture) return _texture;
    
    NSDictionary<MTKTextureLoaderOption, id> *textureLoaderOptions = @{
        MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft,
        MTKTextureLoaderOptionSRGB: @NO,
        MTKTextureLoaderOptionGenerateMipmaps: @YES
    };
    
    NSString * _Nullable fileExtension;
    if ([NSURL fileURLWithPath:filename].pathExtension.length) {
        fileExtension = nil;
    } else {
        fileExtension = UTTypePNG.preferredFilenameExtension;
    }
    
    NSURL *url = [NSBundle.mainBundle URLForResource:filename withExtension:fileExtension];
    assert(url);
    
    id<MTLTexture> texture = [textureLoader newTextureWithContentsOfURL:url options:textureLoaderOptions error:&error];
    NSAssert(!error, error.localizedDescription);
    
    return texture;
}

@end
