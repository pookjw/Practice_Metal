//
//  InputController.m
//  Chapter8
//
//  Created by Jinwoo Kim on 5/3/23.
//

#import "InputController.h"
#import <TargetConditionals.h>
#if TARGET_OS_MACCATALYST
#import <AppKit/AppKit.h>
#endif

@interface InputController ()
@end

@implementation InputController

+ (InputController *)sharedInstance {
    static InputController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [InputController new];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(didReceiveKeyboardDidConnectNotification:)
                                                   name:GCKeyboardDidConnectNotification
                                                 object:nil];
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(didReceiveMouseDidConnectNotification:)
                                                   name:GCMouseDidConnectNotification
                                                 object:nil];
        
#if TARGET_OS_MACCATALYST
        // Beep 소리 비활성화
        [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyUp ^ NSEventMaskKeyDown handler:^NSEvent * _Nullable (NSEvent *event) { return nil; }];
        NSLog(@"%@", NSEvent.class);
#endif
        
        self->_keysPressed = [NSMutableSet new];
    }
    
    return self;
}

- (void)setTouchDelta:(CGSize)touchDelta {
    touchDelta.height *= -1.f;
    
    if (CGSizeEqualToSize(touchDelta, CGSizeZero)) {
        self->_leftMouseDown = NO;
    } else {
        self.mouseDelta = CGPointMake(touchDelta.width, touchDelta.height);
        self->_leftMouseDown = YES;
    }
    
    self->_touchDelta = touchDelta;
}

- (void)didReceiveKeyboardDidConnectNotification:(NSNotification *)notification {
    GCKeyboard *keyboard = notification.object;
    NSMutableSet<NSNumber *> *keysPressed = self.keysPressed;
    
    keyboard.keyboardInput.keyChangedHandler = ^(GCKeyboardInput * _Nonnull keyboard, GCControllerButtonInput * _Nonnull key, GCKeyCode keyCode, BOOL pressed) {
        if (pressed) {
            [keysPressed addObject:[NSNumber numberWithLong:keyCode]];
        } else {
            [keysPressed removeObject:[NSNumber numberWithLong:keyCode]];
        }
    };
}

- (void)didReceiveMouseDidConnectNotification:(NSNotification *)notification {
    GCMouse *mouse = notification.object;
    
    BOOL *leftMouseDown = &self->_leftMouseDown;
    mouse.mouseInput.leftButton.pressedChangedHandler = ^(GCControllerButtonInput * _Nonnull button, float value, BOOL pressed) {
        *leftMouseDown = pressed;
    };
    
    CGPoint *mouseDelta = &self->_mouseDelta;
    mouse.mouseInput.mouseMovedHandler = ^(GCMouseInput * _Nonnull mouse, float deltaX, float deltaY) {
        *mouseDelta = CGPointMake(deltaX, deltaY);
    };
    
    CGPoint *mouseScroll = &self->_mouseScroll;
    mouse.mouseInput.scroll.valueChangedHandler = ^(GCControllerDirectionPad * _Nonnull dpad, float xValue, float yValue) {
        (*mouseScroll).x = xValue;
        (*mouseScroll).y = yValue;
    };
}

@end
