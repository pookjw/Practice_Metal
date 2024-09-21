//
//  Submesh.h
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import <MetalKit/MetalKit.h>
#import "Textures.h"

NS_ASSUME_NONNULL_BEGIN

@interface Submesh : NSObject
@property (assign, nonatomic, readonly) NSUInteger indexCount;
@property (assign, nonatomic, readonly) MTLIndexType indexType;
@property (retain, nonatomic, readonly) id<MTLBuffer> indexBuffer;
@property (assign, nonatomic, readonly) NSUInteger indexBufferOffset;
@property (retain, nonatomic, readonly) Textures *textures;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMDLSubmesh:(MDLSubmesh *)mdlSubmesh mtkSubmesh:(MTKSubmesh *)mtkSubmesh device:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
