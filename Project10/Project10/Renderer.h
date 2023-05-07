//
//  Renderer.h
//  Project10
//
//  Created by Jinwoo Kim on 5/7/23.
//

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Renderer : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMTKView:(MTKView *)mtkView;
- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
