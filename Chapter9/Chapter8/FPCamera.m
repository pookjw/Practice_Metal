//
//  FPCamera.m
//  Chapter8
//
//  Created by Jinwoo Kim on 5/3/23.
//

#import "FPCamera.h"
#import "MathLibrary.h"

@implementation FPCamera

@synthesize transform = _transform;

- (instancetype)init {
    if (self = [super init]) {
        self->_aspect = 1.f;
        self->_fov = [MathLibrary radiansFromDegrees:70.f];
        self->_near = 0.1f;
        self->_far = 100.f;
        self->_transform = [Transform new];
    }
    
    return self;
}

- (simd_float4x4)projectionMatrix {
    return [MathLibrary float4x4FromProjectionFov:self.fov near:self.near far:self.far aspect:self.aspect];
}

- (simd_float4x4)viewMatrix {
    return simd_inverse(
                        matrix_multiply(
                                        [MathLibrary float4x4FromTranslation:self.transform.position],
                                        [MathLibrary float4x4FromFloat3RotationYXZAngle:self.transform.rotation]
                                        )
                        );
    
//    return simd_inverse(
//                        matrix_multiply(
//                                        [MathLibrary float4x4FromFloat3RotationYXZAngle:self.transform.rotation],
//                                        [MathLibrary float4x4FromTranslation:self.transform.position]
//                                        )
//                        );
}

- (void)updateWithSize:(CGSize)size {
    self.aspect = size.width / size.height;
}

- (void)updateWithDeltaTime:(float)deltaTime {
    
}

@end
