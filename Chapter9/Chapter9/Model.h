//
//  Model.h
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import <Metal/Metal.h>
#import "Mesh.h"
#import "Transform.h"
#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject
@property (retain, nonatomic, readonly) Transform *transform;
@property (assign, nonatomic) uint32_t tiling;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name device:(id<MTLDevice>)device;
- (void)setTextureWithName:(NSString *)name type:(TextureIndices)type device:(id<MTLDevice>)device;
- (void)renderInEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)vertex params:(Params)fragment;
@end

NS_ASSUME_NONNULL_END
