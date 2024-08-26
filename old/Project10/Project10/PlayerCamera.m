//
//  PlayerCamera.m
//  Chapter8
//
//  Created by Jinwoo Kim on 5/5/23.
//

#import "PlayerCamera.h"
#import "MathLibrary.h"
#import "InputController.h"
#import "Settings.h"

@interface PlayerCamera ()
@property (assign) simd_float3 lastPosition;
@end

@implementation PlayerCamera

@synthesize transform = _transform;
@synthesize movement = _movement;

- (instancetype)init {
    if (self = [super init]) {
        self->_aspect = 1.f;
        self->_fov = [MathLibrary radiansFromDegrees:70.f];
        self->_near = 0.1f;
        self->_far = 100.f;
        
        self->_transform = [Transform new];
        self->_movement = [[Movement alloc] initWithTransform:self->_transform];
    }
    
    return self;
}

- (simd_float4x4)projectionMatrix {
    return [MathLibrary float4x4FromProjectionFov:self.fov near:self.near far:self.far aspect:self.aspect];
}

- (simd_float4x4)viewMatrix {
    simd_float4x4 rotateMatrix = [MathLibrary float4x4FromFloat3RotationYXZAngle:simd_make_float3(-self.transform.rotation.x, self.transform.rotation.y, 0.f)];
    return simd_inverse(simd_mul([MathLibrary float4x4FromTranslation:self.transform.position], rotateMatrix));
}

- (void)updateWithSize:(CGSize)size {
    self.aspect = size.width / size.height;
}

- (void)updateWithDeltaTime:(float)deltaTime {
    Transform *transform = [self.movement updateInputWithDeltaTime:deltaTime];
    self.transform->_rotation += transform.rotation;
    self.lastPosition += transform.position;
    
    InputController *input = InputController.sharedInstance;
    
    if (input.leftMouseDown) {
        float sensitivity = Settings.moustPanSensitivity;
        self.transform->_rotation.x += input.mouseDelta.y * sensitivity;
        self.transform->_rotation.y += input.mouseDelta.x * sensitivity;
        self.transform->_rotation.x = MAX(-M_PI_2, MIN(self.transform.rotation.x, M_PI_2));
        input.mouseDelta = CGPointZero;
    }
}

@end
