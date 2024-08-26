//
//  Quad.h
//  Chapter4
//
//  Created by Jinwoo Kim on 8/26/24.
//

#import <MetalKit/MetalKit.h>
#include <vector>

struct Vertex {
    float x, y, z;
};

NS_ASSUME_NONNULL_BEGIN

@interface Quad : NSObject
@property (assign, nonatomic) std::vector<Vertex> vertices;
@property (assign, nonatomic) std::vector<std::uint16_t> indices;
@property (assign, nonatomic) std::vector<simd_float3> colors;
@property (retain, nonatomic, readonly) id<MTLBuffer> vertexBuffer;
@property (retain, nonatomic, readonly) id<MTLBuffer> indexBuffer;
@property (retain, nonatomic, readonly) id<MTLBuffer> colorBuffer;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id<MTLDevice>)device scale:(float)scale;
@end

NS_ASSUME_NONNULL_END
