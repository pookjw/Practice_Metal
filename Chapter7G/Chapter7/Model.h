//
//  Model.h
//  Chapter6
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import <MetalKit/MetalKit.h>
#import "Transform.h"

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject
@property (retain, nonatomic, readonly) Transform *transform;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id<MTLDevice>)device name:(NSString *)name;
- (void)renderInEncoder:(id<MTLRenderCommandEncoder>)encoder;
@end

NS_ASSUME_NONNULL_END
