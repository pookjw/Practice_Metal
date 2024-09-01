//
//  SubmeshTextures.h
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubmeshTextures : NSObject
@property (retain, nonatomic, nullable) id<MTLTexture> baseColor;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMaterial:(MDLMaterial *)material device:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
