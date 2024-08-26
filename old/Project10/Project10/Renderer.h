//
//  Renderer.h
//  Project10
//
//  Created by Jinwoo Kim on 5/7/23.
//

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>
#import "GameScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface Renderer : NSObject
@property (readonly, strong) id<MTLDevice> device;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMTKView:(MTKView *)mtkView;
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size;
- (void)drawInScene:(GameScene *)scene view:(MTKView *)view;
@end

NS_ASSUME_NONNULL_END
