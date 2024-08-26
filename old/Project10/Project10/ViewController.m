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
#import "Settings.h"

@interface ViewController ()
@property (strong) GameController *gameController;
@property (assign) CGPoint previousTranslation;
@property (assign) CGFloat previousScroll;
@end

@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
        self.previousTranslation = CGPointZero;
        self.previousScroll = 1.f;
    }
    
    return self;
}

- (void)loadView {
    MTKView *mtkView = [MTKView new];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didTriggerPanGesture:)];
    [mtkView addGestureRecognizer:panGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didTriggerPinchGesture:)];
    [mtkView addGestureRecognizer:pinchGesture];
    
    GameController *gameController = [[GameController alloc] initWithMTKView:mtkView];
    
    self.view = mtkView;
    self.gameController = gameController;
}

- (void)didTriggerPanGesture:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
            InputController.sharedInstance.touchLocation = [sender locationInView:sender.view];
            
            CGPoint translation = [sender translationInView:sender.view];
            
            InputController.sharedInstance.touchDelta = CGSizeMake(
                                                                   translation.x - self.previousTranslation.x,
                                                                   translation.y - self.previousTranslation.y
                                                                   );
            
            self.previousTranslation = translation;
            break;
        case UIGestureRecognizerStateEnded:
            self.previousTranslation = CGPointZero;
            break;
        default:
            break;
    }
}

- (void)didTriggerPinchGesture:(UIPinchGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateChanged: {
            CGFloat scroll = sender.scale - self.previousScroll;
            InputController.sharedInstance->mouseScroll.x = scroll * Settings.touchZoomSensitivity;
            self.previousScroll = sender.scale;
            break;
        }
        case UIGestureRecognizerStateEnded:
            self.previousScroll = 1.f;
            break;
        default:
            break;
    }
}

@end
