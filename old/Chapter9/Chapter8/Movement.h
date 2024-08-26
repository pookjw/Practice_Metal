//
//  Movement.h
//  Chapter8
//
//  Created by Jinwoo Kim on 5/5/23.
//

#import <Foundation/Foundation.h>
#import "Transform.h"

NS_ASSUME_NONNULL_BEGIN

@class Movement;
@protocol Movable <Transformable>
@property (readonly) Movement *movement;
@end

@interface Movement : NSObject
@property (readonly, nonatomic) simd_float3 forwardVector;
@property (readonly, nonatomic) simd_float3 rightVector;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTransform:(Transform *)transform;
- (Transform *)updateInputWithDeltaTime:(float)deltaTime;
@end

NS_ASSUME_NONNULL_END
