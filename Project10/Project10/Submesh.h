//
//  Submesh.h
//  Project10
//
//  Created by Jinwoo Kim on 5/8/23.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Textures : NSObject
@property (readonly, assign, nullable) id<MTLTexture> baseColor;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

@interface Submesh : NSObject
@property (readonly, assign) NSUInteger indexCount;
@property (readonly, assign) MTLIndexType indexType;
@property (readonly, strong) id<MTLBuffer> indexBuffer;
@property (readonly, assign) NSUInteger indexBufferOffset;
@property (readonly, strong) Textures *textures;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMDLSubMesh:(MDLSubmesh *)mdlSubmesh mtkSubmesh:(MTKSubmesh *)mtkSubmesh device:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
