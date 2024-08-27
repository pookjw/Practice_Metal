//
//  Triangle.h
//  Chapter5
//
//  Created by Jinwoo Kim on 8/27/24.
//

#import <MetalKit/MetalKit.h>
#include <vector>
#import "Vertex.h"

NS_ASSUME_NONNULL_BEGIN

@interface Triangle : NSObject
@property (assign, nonatomic, readonly) std::vector<Vertex> vertices;
@property (assign, nonatomic, readonly) std::vector<std::uint16_t> indices;
@property (retain, nonatomic, readonly) id<MTLBuffer> vertexBuffer;
@property (retain, nonatomic, readonly) id<MTLBuffer> indexBuffer;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id<MTLDevice>)device scale:(float)scale;
@end

NS_ASSUME_NONNULL_END
