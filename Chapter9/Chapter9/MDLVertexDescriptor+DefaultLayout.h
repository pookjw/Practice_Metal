//
//  MDLVertexDescriptor+DefaultLayout.h
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import <ModelIO/ModelIO.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDLVertexDescriptor (DefaultLayout)
@property (class, nonatomic, readonly) MDLVertexDescriptor *defaultLayout;
@end

NS_ASSUME_NONNULL_END
