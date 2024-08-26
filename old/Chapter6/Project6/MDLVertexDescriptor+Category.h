//
//  MDLVertexDescriptor+Category.h
//  Project6
//
//  Created by Jinwoo Kim on 4/13/23.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDLVertexDescriptor (Category)
@property (class, readonly, nonatomic) MDLVertexDescriptor *defaultLayout;
@end

NS_ASSUME_NONNULL_END
