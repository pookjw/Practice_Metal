//
//  Mesh.h
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import <Metal/Metal.h>
#import "Submesh.h"

NS_ASSUME_NONNULL_BEGIN

@interface Mesh : NSObject
@property (retain, nonatomic, readonly) NSArray<id<MTLBuffer>> *vertexBuffers;
@property (retain, nonatomic, readonly) NSArray<Submesh *> *submeshes;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMDLMesh:(MDLMesh *)mdlMesh mtkMesh:(MTKMesh *)mtkMesh device:(id<MTLDevice>)device;
@end

NS_ASSUME_NONNULL_END
