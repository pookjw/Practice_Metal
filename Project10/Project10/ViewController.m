//
//  ViewController.m
//  Project10
//
//  Created by Jinwoo Kim on 5/7/23.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>
#import "GameController.h"
#import "InputController.h"

@interface ViewController ()
@property (strong) GameController *gameController;
@property (assign) CGSize previousTranslation;
@property (assign) CGFloat previousScroll;
@end

@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
        self.previousTranslation = CGSizeZero;
        self.previousScroll = 1.f;
    }
    
    return self;
}

- (void)loadView {
    MTKView *mtkView = [MTKView new];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didTriggerPanGesture:)];
    [mtkView addGestureRecognizer:panGesture];
    
    GameController *gameController = [[GameController alloc] initWithMTKView:mtkView];
    
    self.view = mtkView;
    self.gameController = gameController;
}

- (void)didTriggerPanGesture:(UIPanGestureRecognizer *)sender {
    // TODO
}

@end
