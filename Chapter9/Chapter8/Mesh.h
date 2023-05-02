//
//  Mesh.h
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import <MetalKit/MetalKit.h>
#import "Submesh.h"

NS_ASSUME_NONNULL_BEGIN

@interface Mesh : NSObject
@property (readonly, strong) NSArray<id<MTLBuffer>> *vertexBuffers;
@property (readonly, strong) NSArray<Submesh *> *submeshes;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMDLMesh:(MDLMesh *)mdlMesh mtkMesh:(MTKMesh *)mtkMesh device:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
