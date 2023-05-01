//
//  TextureController.h
//  Chapter8
//
//  Created by Jinwoo Kim on 5/1/23.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextureController : NSObject
+ (id<MTLTexture> _Nullable)textureFromFilename:(NSString *)filename device:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
