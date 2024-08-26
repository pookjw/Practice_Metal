//
//  GameScene.h
//  Project10
//
//  Created by Jinwoo Kim on 5/8/23.
//

#import <MetalKit/MetalKit.h>
#import "ArcballCamera.h"
#import "Model.h"
#import "SceneLighting.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameScene : NSObject
@property (readonly, strong) ArcballCamera *camera;
@property (readonly, strong) NSArray<Model *> *models;
@property (readonly, strong) SceneLighting *lighting;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id<MTLDevice>)device;
- (void)updateWithSize:(CGSize)size;
- (void)updateWithDeltaTime:(float)deltaTime;
@end

NS_ASSUME_NONNULL_END
