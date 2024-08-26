//
//  Model.h
//  Chapter7
//
//  Created by Jinwoo Kim on 4/14/23.
//

#import <MetalKit/MetalKit.h>
#import "Transform.h"

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject <Transformable>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id<MTLDevice>)device name:(NSString *)name;
- (void)renderWithEncoder:(id<MTLRenderCommandEncoder>)encoder;
@end

NS_ASSUME_NONNULL_END
