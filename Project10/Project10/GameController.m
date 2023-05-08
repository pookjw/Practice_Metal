//
//  GameController.m
//  Project10
//
//  Created by Jinwoo Kim on 5/8/23.
//

#import "GameController.h"
#import "GameScene.h"
#import "Renderer.h"

@interface GameController () <MTKViewDelegate>
@property (strong) GameScene *scene;
@property (strong) Renderer *renderer;
@property (assign) double fps;
@property (assign) double deltaTime;
@property (assign) double lastTime;
@end

@implementation GameController

- (instancetype)initWithMTKView:(MTKView *)mtkView {
    if (self = [self init]) {
        self.renderer = [[Renderer alloc] initWithMTKView:mtkView];
        self.scene = [[GameScene alloc] initWithDevice:self.renderer.device];
        self.lastTime = CFAbsoluteTimeGetCurrent();
        
        mtkView.delegate = self;
        self.fps = mtkView.preferredFramesPerSecond;
        
        [self mtkView:mtkView drawableSizeWillChange:mtkView.drawableSize];
    }
    
    return self;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    [self.scene updateWithSize:size];
    [self.renderer mtkView:view drawableSizeWillChange:size];
}

- (void)drawInMTKView:(nonnull MTKView *)view {
    double currentTime = CFAbsoluteTimeGetCurrent();
    double deltaTime = currentTime - self.lastTime;
    self.lastTime = currentTime;
    
    [self.scene updateWithDeltaTime:deltaTime];
    [self.renderer drawInScene:self.scene view:view];
}

@end
