//
//  ChallengeCamera.h
//  Chapter8
//
//  Created by Jinwoo Kim on 5/5/23.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>
#import "Camera.h"
#import "Movement.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChallengeCamera : NSObject <Camera, Movable>
@property (assign) float aspect;
@property (assign) float fov;
@property (assign) float near;
@property (assign) float far;

@property (readonly, nonatomic) float minDistance;
@property (readonly, nonatomic) float maxDistance;
@property (assign) simd_float3 target;
@property (assign) float distance;
@end

NS_ASSUME_NONNULL_END
