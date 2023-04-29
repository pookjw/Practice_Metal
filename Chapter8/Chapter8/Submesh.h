//
//  Submesh.h
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Submesh : NSObject
@property (readonly, assign) NSInteger indexCount;
@property (readonly, assign) MTLIndexType indexType;
@property (readonly, strong) id<MTLBuffer> indexBuffer;
@property (readonly, assign) NSInteger indexBufferOffset;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMDLSubmesh:(MDLSubmesh *)mdlSubMesh mtkSubmesh:(MTKSubmesh *)mtkSubmesh;
@end

NS_ASSUME_NONNULL_END
