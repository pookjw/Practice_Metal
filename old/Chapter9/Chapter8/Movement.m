//
//  Movement.m
//  Chapter8
//
//  Created by Jinwoo Kim on 5/5/23.
//

#import "Movement.h"
#import "Settings.h"
#import "InputController.h"

@interface Movement ()
@property (strong) Transform *transform;
@end

@implementation Movement

- (instancetype)initWithTransform:(Transform *)transform {
    if (self = [self init]) {
        self.transform = transform;
    }
    
    return self;
}

- (simd_float3)forwardVector {
    return simd_normalize(
                          simd_make_float3(
                                           sinf(self.transform.rotation.y),
                                           0.f,
                                           cosf(self.transform.rotation.y)
                                           )
                          );
}

- (simd_float3)rightVector {
    return simd_make_float3(
                            self.forwardVector.z,
                            self.forwardVector.y,
                            -self.forwardVector.x
                            );
}

- (Transform *)updateInputWithDeltaTime:(float)deltaTime {
    Transform *transform = [Transform new];
    float rotationAmount = deltaTime * Settings.rotationSpeed;
    
    if ([InputController.sharedInstance.keysPressed containsObject:[NSNumber numberWithLong:GCKeyCodeLeftArrow]]) {
        transform->_rotation.y -= rotationAmount;
    }
    
    if ([InputController.sharedInstance.keysPressed containsObject:[NSNumber numberWithLong:GCKeyCodeRightArrow]]) {
        transform->_rotation.y += rotationAmount;
    }
    
    simd_float3 direction = simd_make_float3(0.f, 0.f, 0.f);
    
    if ([InputController.sharedInstance.keysPressed containsObject:@(GCKeyCodeKeyW)]) {
        direction.z += 1.f;
    }
    
    if ([InputController.sharedInstance.keysPressed containsObject:@(GCKeyCodeKeyS)]) {
        direction.z -= 1.f;
    }
    
    if ([InputController.sharedInstance.keysPressed containsObject:@(GCKeyCodeKeyA)]) {
        direction.x -= 1.f;
    }
    
    if ([InputController.sharedInstance.keysPressed containsObject:@(GCKeyCodeKeyD)]) {
        direction.x += 1.f;
    }
    
    float translationAmount = deltaTime * Settings.translationSpeed;
    
    if (!simd_equal(direction, simd_make_float3(0.f, 0.f, 0.f))) {
        direction = simd_normalize(direction);
        transform.position += (direction.z * self.forwardVector + direction.x * self.rightVector) * translationAmount;
    }
    
    return transform;
}

@end
