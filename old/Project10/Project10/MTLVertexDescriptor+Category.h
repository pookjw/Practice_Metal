//
//  MTLVertexDescriptor+Category.h
//  Project10
//
//  Created by Jinwoo Kim on 5/8/23.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLVertexDescriptor (Category)
@property (class, readonly, nonatomic) MTLVertexDescriptor *defaultLayout;
@end

NS_ASSUME_NONNULL_END
