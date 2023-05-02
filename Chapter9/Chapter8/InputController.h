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
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
