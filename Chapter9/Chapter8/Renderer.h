//
//  Renderer.h
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RendererChoice) {
    RendererChoiceTrain,
    RendererChoiceQuad
};

@interface Renderer : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMTKView:(MTKView *)mtkView choice:(RendererChoice)choice;
@end

NS_ASSUME_NONNULL_END
