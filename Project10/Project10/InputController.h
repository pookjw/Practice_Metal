//
//  InputController.h
//  Chapter8
//
//  Created by Jinwoo Kim on 5/3/23.
//

#import <GameController/GameController.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputController : NSObject
@property (class, readonly, nonatomic) InputController *sharedInstance;
@property (strong, readonly) NSMutableSet<NSNumber *> *keysPressed;
@property (readonly, assign) BOOL leftMouseDown;
@property (assign) CGPoint mouseDelta;
@property (assign) CGPoint mouseScroll;
@property (assign) CGPoint touchLocation;
@property (assign, nonatomic) CGSize touchDelta;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
