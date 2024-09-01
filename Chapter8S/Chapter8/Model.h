//
//  Model.h
//  Chapter6
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import <MetalKit/MetalKit.h>
#import "Transform.h"
#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, Primitive) {
    PrimitivePlane,
    PrimitiveSphere
};

@interface Model : NSObject
@property (retain, nonatomic, readonly) Transform *transform;
+ (MDLMesh *)createMeshWithPrimitive:(Primitive)primitive device:(id<MTLDevice>)device;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id<MTLDevice>)device name:(NSString *)name;
- (instancetype)initWithDevice:(id<MTLDevice>)device name:(NSString *)name primitive:(Primitive)primitive;
- (void)renderInEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)uniforms params:(Params)params;
@end

NS_ASSUME_NONNULL_END
