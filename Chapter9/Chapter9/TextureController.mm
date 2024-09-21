//
//  TextureController.mm
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import "TextureController.h"

@interface TextureController ()
@property (retain, nonatomic, readonly) NSMutableDictionary<NSString *, id<MTLTexture>> *textures;
@end

@implementation TextureController

+ (TextureController *)sharedInstance {
    static TextureController *instance;
    
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

- (id<MTLTexture>)loadTextureFromTexture:(MDLTexture *)texture name:(NSString *)name device:(id<MTLDevice>)device {
    if (auto texture = _textures[name]) {
        return texture;
    }
    
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    NSDictionary<MTKTextureLoaderOption, id> *options = @{
        MTKTextureLoaderOptionOrigin: MTKTextureLoaderOriginBottomLeft,
        MTKTextureLoaderOptionGenerateMipmaps: @YES
    };
    
    NSError * _Nullable error = nil;
    id<MTLTexture> mtlTexture = [textureLoader newTextureWithMDLTexture:texture options:options error:&error];
    [textureLoader release];
    assert(error == nil);
    
    _textures[name] = mtlTexture;
    return [mtlTexture autorelease];
}

- (id<MTLTexture>)loadTextureFromName:(NSString *)name device:(id<MTLDevice>)device {
    if (auto texture = _textures[name]) {
        return texture;
    }
    
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    
    NSError * _Nullable error = nil;
    id<MTLTexture> mtlTexture = [textureLoader newTextureWithName:name scaleFactor:1. bundle:NSBundle.mainBundle options:nil error:&error];
    [textureLoader release];
    assert(error == nil);
    
    _textures[name] = mtlTexture;
    return [mtlTexture autorelease];
}

@end
