//
//  FPCamera.h
//  Chapter8
//
//  Created by Jinwoo Kim on 5/3/23.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>
#import "Camera.h"

NS_ASSUME_NONNULL_BEGIN

@interface FPCamera : NSObject <Camera>
@property (assign) float aspect;
@property (assign) float fov;
@property (assign) float near;
@property (assign) float far;
@end

NS_ASSUME_NONNULL_END
