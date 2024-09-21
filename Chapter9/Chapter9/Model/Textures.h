//
//  Textures.h
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import <Metal/Metal.h>
#import <ModelIO/ModelIO.h>

NS_ASSUME_NONNULL_BEGIN

@interface Textures : NSObject
@property (retain, nullable) id<MTLTexture> baseColor;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMaterial:(MDLMaterial *)material device:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
