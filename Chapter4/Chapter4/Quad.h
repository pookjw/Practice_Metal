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
@property (readonly, assign) NSUInteger count;
@property (readonly, strong) id<MTLBuffer> vertexBuffer;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id<MTLDevice>)device scale:(float)scale;
@end

NS_ASSUME_NONNULL_END
