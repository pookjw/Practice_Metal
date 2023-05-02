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
        
#if TARGET_OS_MACCATALYST
        // Beep 소리 비활성화
        [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyUp ^ NSEventMaskKeyDown handler:^NSEvent * _Nullable (NSEvent *event) { return nil; }];
        NSLog(@"%@", NSEvent.class);
#endif
        
        self->_keysPressed = [NSMutableSet new];
    }
    
    return self;
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

@end
