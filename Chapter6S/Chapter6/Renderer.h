//
//  Renderer.h
//  Chapter6
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Renderer : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMetalView:(MTKView *)metalView;
@end

NS_ASSUME_NONNULL_END
