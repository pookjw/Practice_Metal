//
//  Model.h
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import <MetalKit/MetalKit.h>
#import "Transform.h"
#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject <Transformable>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name device:(id<MTLDevice>)device;
- (void)renderInEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)uniforms params:(Params)params;
@end

NS_ASSUME_NONNULL_END
