//
//  MTLVertexDescriptor+DefaultLayout.h
//  Chapter7
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLVertexDescriptor (DefaultLayout)
+ (MTLVertexDescriptor *)defaultLayout;
@end

@interface MDLVertexDescriptor (DefaultLayout)
+ (MDLVertexDescriptor *)defaultLayout;
@end

NS_ASSUME_NONNULL_END
