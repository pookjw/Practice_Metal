//
//  Submesh.h
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubmeshTextures : NSObject
@property (readonly, nullable) id<MTLTexture> baseColor;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMaterial:(MDLMaterial * _Nullable)material device:(id<MTLDevice>)device;
@end

@interface Submesh : NSObject
@property (readonly, assign) NSInteger indexCount;
@property (readonly, assign) MTLIndexType indexType;
@property (readonly, strong) id<MTLBuffer> indexBuffer;
@property (readonly, assign) NSInteger indexBufferOffset;
@property (readonly, strong) SubmeshTextures *textures;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMDLSubmesh:(MDLSubmesh *)mdlSubMesh mtkSubmesh:(MTKSubmesh *)mtkSubmesh device:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
