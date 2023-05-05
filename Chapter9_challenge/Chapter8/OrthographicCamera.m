//
//  OrthographicCamera.m
//  Chapter8
//
//  Created by Jinwoo Kim on 5/5/23.
//

#import "OrthographicCamera.h"
#import "MathLibrary.h"
#import "InputController.h"

@interface OrthographicCamera ()
@property CGFloat aspect;
@property CGFloat viewSize;
@property float near;
@property float far;
@end

@implementation OrthographicCamera

@synthesize transform = _transform;
@synthesize movement = _movement;

- (instancetype)init {
    if (self = [super init]) {
        self.aspect = 1.f;
        self.viewSize = 10.f;
        self.near = 0.1f;
        self.far = 100.f;
        
        self->_transform = [Transform new];
        self->_movement = [[Movement alloc] initWithTransform:self.transform];
    }
    
    return self;
}

- (simd_float4x4)viewMatrix {
    return simd_inverse(
                        simd_mul(
                                 [MathLibrary float4x4FromTranslation:self.transform.position],
                                 [MathLibrary float4x4FromFloat3RotationAngle:self.transform.rotation]
                                 )
                        );
}

- (simd_float4x4)projectionMatrix {
    CGRect rect = CGRectMake(
                             -self.viewSize * self.aspect * 0.5f,
                             self.viewSize * 0.5f,
                             self.viewSize * self.aspect,
                             self.viewSize
                             );
    
    return [MathLibrary float4x4FromOrthographic:rect near:self.near far:self.far];
}

- (void)updateWithSize:(CGSize)size { 
    self.aspect = size.width / size.height;
}

- (void)updateWithDeltaTime:(float)deltaTime { 
    Transform *transform = [self.movement updateInputWithDeltaTime:deltaTime];
    self.transform->_position += transform.position;
    
    InputController *input = InputController.sharedInstance;
    float zoom = input.mouseScroll.x + input.mouseScroll.y;
    self.viewSize -= zoom;
    input.mouseScroll = CGPointZero;
}

@end
