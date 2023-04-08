//
//  Triangle.h
//  Chapter5
//
//  Created by Jinwoo Kim on 4/8/23.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Triangle : NSObject {
@public float vertices[9];
@public uint16_t indices[3];
}
@property (readonly, strong) id<MTLBuffer> vertexBuffer;
@property (readonly, strong) id<MTLBuffer> indexBuffer;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
