//
//  GameScene.h
//  Chapter8
//
//  Created by Jinwoo Kim on 5/2/23.
//

#import <MetalKit/MetalKit.h>
#import "Model.h"
#import "Camera.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameScene : NSObject
@property (strong, readonly) NSArray<Model *> *models;
@property (strong, readonly) id<Camera> camera;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id<MTLDevice>)device;
- (void)updateWithDeltaTime:(float)deltaTime;
- (void)updateWithSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
