//
//  Submesh.h
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#import <MetalKit/MetalKit.h>
#import "SubmeshTextures.h"

NS_ASSUME_NONNULL_BEGIN

@interface Submesh : NSObject
@property (assign, readonly, nonatomic) NSUInteger indexCount;
@property (assign, readonly, nonatomic) MTLIndexType indexType;
@property (retain, readonly, nonatomic) id<MTLBuffer> indexBuffer;
@property (assign, readonly, nonatomic) NSUInteger indexBufferOffset;
@property (retain, readonly, nonatomic) SubmeshTextures *textures;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMDLSubmesh:(MDLSubmesh *)mdlSubmesh mtkSubmesh:(MTKSubmesh *)mtkSubmesh device:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
