//
//  GameScene.m
//  Project10
//
//  Created by Jinwoo Kim on 5/8/23.
//

#import "GameScene.h"
#import "Transform.h"
#import "InputController.h"
#import "MathLibrary.h"

@interface GameScene ()
@property (strong) Model *sphere;
@property (strong) Model *gizmo;

@property (strong) Transform *defaultView;
@end

@implementation GameScene

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    if (self = [self init]) {
        self.sphere = [[Model alloc] initWithName:@"sphere.obj" device:device];
        self.gizmo = [[Model alloc] initWithName:@"gizmo.usd" device:device];
        self->_models = @[self.sphere, self.gizmo];
        
        Transform *defaultView = [Transform new];
        defaultView->_position = simd_make_float3(-1.18f, 1.57f, -1.28f);
        defaultView->_rotation = simd_make_float3(-0.73f, 13.3f, 0.f);
        
        self.defaultView = defaultView;
        
        ArcballCamera *camera = [ArcballCamera new];
        camera.distance = 2.5f;
        camera->_transform = defaultView;
        
        self->_camera = camera;
        self->_lighting = [SceneLighting new];
    }
    
    return self;
}

- (void)updateWithSize:(CGSize)size {
    [self.camera updateWithSize:size];
}

- (void)updateWithDeltaTime:(float)deltaTime {
    InputController *input = InputController.sharedInstance;
    
    if ([input.keysPressed containsObject:@(GCKeyCodeOne)]) {
        self.camera->_transform = [Transform new];
    }
    
    if ([input.keysPressed containsObject:@(GCKeyCodeTwo)]) {
        self.camera->_transform = self.defaultView;
    }
    
    [self.camera updateWithDeltaTime:deltaTime];
    [self calculateGizmo];
}

- (void)calculateGizmo {
    simd_float4x4 lookAt = [MathLibrary float4x4FromEye:self.camera.transform.position
                                                 center:simd_make_float3(0.f, 0.f, 0.f)
                                                     up:simd_make_float3(0.f, 1.f, 0.f)];
    
    simd_float3 forwardVector = simd_make_float3(lookAt.columns[0].z, lookAt.columns[1].z, lookAt.columns[2].z);
    simd_float3 rightVector = simd_make_float3(lookAt.columns[0].x, lookAt.columns[1].x, lookAt.columns[2].x);
    
    float heightNear = 2.f * tanf(self.camera.fov * 0.5f) * self.camera.near;
    float widthNear = heightNear * self.camera.aspect;
    simd_float3 cameraNear = self.camera.transform.position + forwardVector * self.camera.near;
    simd_float3 cameraUp = simd_make_float3(0.f, 1.f, 0.f);
    simd_float3 bottomLeft = cameraNear - (cameraUp * (heightNear * 0.5f)) - (rightVector * (widthNear * 0.5f));
    self.gizmo.transform->_position = bottomLeft;
    self.gizmo.transform->_position = (forwardVector - rightVector) * 10.f;
}

@end
