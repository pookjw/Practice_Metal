//
//  Quad.h
//  Chapter4
//
//  Created by Jinwoo Kim on 4/7/23.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Quad : NSObject
@property (readonly, assign) float *vertices;
@property (readonly, assign) NSUInteger verticesCount;

@property (readonly, assign) ushort *indices;
@property (readonly, assign) NSUInteger indicesCount;

@property (readonly, assign) simd_float3 *colors;
@property (readonly, assign) NSUInteger colorsCount;

@property (readonly, strong) id<MTLBuffer> vertexBuffer;
@property (readonly, strong) id<MTLBuffer> indexBuffer;
@property (readonly, strong) id<MTLBuffer> colorBuffer;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id<MTLDevice>)device scale:(float)scale;
@end

NS_ASSUME_NONNULL_END
