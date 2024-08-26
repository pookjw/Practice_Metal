//
//  ArcballCamera.m
//  Chapter8
//
//  Created by Jinwoo Kim on 5/3/23.
//

#import "ArcballCamera.h"
#import "MathLibrary.h"
#import "InputController.h"
#import "Settings.h"

@implementation ArcballCamera

@synthesize transform = _transform;
@synthesize movement = _movement;

- (instancetype)init {
    if (self = [super init]) {
        self->_aspect = 1.f;
        self->_fov = [MathLibrary radiansFromDegrees:70.f];
        self->_near = 0.1f;
        self->_far = 100.f;
        
        self.target = simd_make_float3(0.f, 0.f, 0.f);
        self.distance = 2.5f;
        
        self->_transform = [Transform new];
        self->_movement = [[Movement alloc] initWithTransform:self->_transform];
    }
    
    return self;
}

- (float)minDistance {
    return 0.f;
}

- (float)maxDistance {
    return 20.f;
}

- (simd_float4x4)projectionMatrix {
    return [MathLibrary float4x4FromProjectionFov:self.fov near:self.near far:self.far aspect:self.aspect];
}

- (simd_float4x4)viewMatrix {
    if (simd_equal(self.target, self.transform.position)) {
        return simd_inverse(
                            simd_mul(
                                     [MathLibrary float4x4FromTranslation:self.target],
                                     [MathLibrary float4x4FromFloat3RotationYXZAngle:self.transform.rotation]
                                     )
                            );
    } else {
        return [MathLibrary float4x4FromEye:self.transform.position center:self.target up:simd_make_float3(0.f, 1.f, 0.f)];
    }
}

- (void)updateWithSize:(CGSize)size {
    self.aspect = size.width / size.height;
}

- (void)updateWithDeltaTime:(float)deltaTime {
    InputController *input = InputController.sharedInstance;
    float scrollSensitivity = Settings.mouseScrollSensitivity;
    self.distance -= (input.mouseScroll.x + input.mouseScroll.y) * scrollSensitivity;
    self.distance = MIN(self.maxDistance, self.distance);
    self.distance = MAX(self.minDistance, self.distance);
    
    input.mouseScroll = CGPointZero;
    
    if (input.leftMouseDown) {
        float sensitivity = Settings.moustPanSensitivity;
        self.transform->_rotation.x += input.mouseDelta.y * sensitivity;
        self.transform->_rotation.y += input.mouseDelta.x * sensitivity;
        self.transform->_rotation.x = MAX(-M_PI_2, MIN(self.transform.rotation.x, M_PI_2));
        input.mouseDelta = CGPointZero;
    }
    
    simd_float4x4 rotateMatrix = [MathLibrary float4x4FromFloat3RotationYXZAngle:simd_make_float3(-self.transform.rotation.x, self.transform.rotation.y, 0.f)];
    simd_float4 distanceVector = simd_make_float4(0.f, 0.f, -self.distance, 0.f);
    simd_float4 rotatedVector = simd_mul(rotateMatrix, distanceVector);
    self.transform.position = self.target + rotatedVector.xyz;
}

@end
