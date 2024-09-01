//
//  Mesh.h
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#import "Submesh.h"

NS_ASSUME_NONNULL_BEGIN

@interface Mesh : NSObject
@property (retain, readonly, nonatomic) NSArray<id<MTLBuffer>> *vertexBuffers;
@property (retain, readonly, nonatomic) NSArray<Submesh *> *submeshes;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMDLMesh:(MDLMesh *)mdlMesh mtkMesh:(MTKMesh *)mtkMesh device:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
