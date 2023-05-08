//
//  Model.h
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import <MetalKit/MetalKit.h>
#import "Transform.h"
#import "common.h"

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject <Transformable>
@property float tiling;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name device:(id<MTLDevice>)device;
- (void)renderInEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)vertex params:(Params)fragment;
@end

NS_ASSUME_NONNULL_END
