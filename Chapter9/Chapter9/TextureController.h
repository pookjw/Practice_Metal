//
//  TextureController.h
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextureController : NSObject
@property (class, nonatomic, readonly) TextureController *sharedInstance;
- (id<MTLTexture>)loadTextureFromTexture:(MDLTexture *)texture name:(NSString *)name device:(id<MTLDevice>)device;
- (id<MTLTexture>)loadTextureFromName:(NSString *)name device:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
