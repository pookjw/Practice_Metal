//
//  MTLVertexDescriptor+DefaultLayout.h
//  Chapter5
//
//  Created by Jinwoo Kim on 8/27/24.
//

#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLVertexDescriptor (DefaultLayout)
+ (MTLVertexDescriptor *)defaultLayout;
@end

NS_ASSUME_NONNULL_END
