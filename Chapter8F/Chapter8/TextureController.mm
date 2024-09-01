//
//  TextureController.m
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#import "TextureController.h"

@interface TextureController ()
@property (retain, readonly, nonatomic) NSMutableDictionary<NSString *, id<MTLTexture>> *textures;
@end

@implementation TextureController

+ (TextureController *)sharedInstance {
    static TextureController *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TextureController new];
    });
    
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _textures = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc {
    [_textures release];
    [super dealloc];
}

- (id<MTLTexture>)loadTexture:(MDLTexture *)mdlTexture device:(id<MTLDevice>)device name:(NSString *)name {
    if (auto texture = self.textures[name]) {
        return texture;
    }
    
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    NSDictionary<MTKTextureLoaderOption, id> *textureLoaderOptions = @{
        MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft,
        MTKTextureLoaderOptionGenerateMipmaps: @YES
    };
    
    NSError * _Nullable error = nil;
    id<MTLTexture> texture = [textureLoader newTextureWithMDLTexture:mdlTexture options:textureLoaderOptions error:&error];
    [textureLoader release];
    assert(error == nil);
    
    self.textures[name] = texture;
    
    return [texture autorelease];
}

- (id<MTLTexture>)loadTextureWithName:(NSString *)name device:(id<MTLDevice>)device {
    if (auto texture = self.textures[name]) {
        return texture;
    }
    
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    
    NSError * _Nullable error = nil;
    id<MTLTexture> texture = [textureLoader newTextureWithName:name scaleFactor:1.0 bundle:NSBundle.mainBundle options:nil error:&error];
    [textureLoader release];
    assert(error == nil);
    
    self.textures[name] = texture;
    
    return [texture autorelease];
}

@end
