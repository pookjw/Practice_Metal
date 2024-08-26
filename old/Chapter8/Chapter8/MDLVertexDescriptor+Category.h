//
//  MDLVertexDescriptor+Category.h
//  Chapter8
//
//  Created by Jinwoo Kim on 5/1/23.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDLVertexDescriptor (Category)
@property (class, readonly, nonatomic) MDLVertexDescriptor *defaultLayout;
@end

NS_ASSUME_NONNULL_END
