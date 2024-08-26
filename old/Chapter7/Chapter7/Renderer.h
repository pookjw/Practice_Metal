//
//  Renderer.h
//  Chapter7
//
//  Created by Jinwoo Kim on 4/14/23.
//

#import <MetalKit/MetalKit.h>
#import "Options.h"

NS_ASSUME_NONNULL_BEGIN

@interface Renderer : NSObject
@property Options options;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMetalView:(MTKView *)metalView options:(Options)options;
@end

NS_ASSUME_NONNULL_END
