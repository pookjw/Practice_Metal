//
//  Grid.h
//  Chapter5
//
//  Created by Jinwoo Kim on 4/8/23.
//

#import <MetalKit/MetalKit.h>
#define GRID_BLOCK_COUNT 20

NS_ASSUME_NONNULL_BEGIN

@interface Grid : NSObject {
@public simd_float3 coords[(GRID_BLOCK_COUNT - 1) * 4];
@public ushort indices[(GRID_BLOCK_COUNT - 1) * 4];
}
@property (readonly, strong) id<MTLBuffer> coordsBuffer;
@property (readonly, strong) id<MTLBuffer> indicesBuffer;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
