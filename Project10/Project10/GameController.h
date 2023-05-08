//
//  GameController.h
//  Project10
//
//  Created by Jinwoo Kim on 5/8/23.
//

#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameController : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMTKView:(MTKView *)mtkView;
@end

NS_ASSUME_NONNULL_END
