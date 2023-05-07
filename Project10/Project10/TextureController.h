//
//  TextureController.h
//  Project10
//
//  Created by Jinwoo Kim on 5/8/23.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextureController : NSObject
+ (id<MTLTexture> _Nullable)textureFromFilename:(NSString *)filename device:(id<MTLDevice>)device;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
