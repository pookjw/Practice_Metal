//
//  TextureController.h
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextureController : NSObject
@property (class, readonly, nonatomic) TextureController *sharedInstance;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (id<MTLTexture>)loadTexture:(MDLTexture *)mdlTexture device:(id<MTLDevice>)device name:(NSString *)name;
- (id<MTLTexture>)loadTextureWithName:(NSString *)name device:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
