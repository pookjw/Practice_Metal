//
//  OrthographicCamera.h
//  Chapter8
//
//  Created by Jinwoo Kim on 5/5/23.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>
#import "Camera.h"
#import "Movement.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrthographicCamera : NSObject <Camera, Movable>

@end

NS_ASSUME_NONNULL_END
