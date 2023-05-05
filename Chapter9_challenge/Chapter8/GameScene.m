//
//  GameScene.m
//  Chapter8
//
//  Created by Jinwoo Kim on 5/2/23.
//

#import "GameScene.h"
#import "InputController.h"
#import "FPCamera.h"
#import "ArcballCamera.h"
#import "OrthographicCamera.h"
#import "ChallengeCamera.h"

@interface GameScene ()
@property (strong) Model *house;
@property (strong) Model *ground;
@end

@implementation GameScene

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    if (self = [self init]) {
        Model *house = [[Model alloc] initWithName:@"lowpoly-house.obj" device:device];
        Model *ground = [[Model alloc] initWithName:@"plane.obj" device:device];
        NSArray<Model *> *models = @[house, ground];
        
//        FPCamera *camera = [FPCamera new];
//        camera.transform.position = simd_make_float3(0.f, 1.5f, -5.f);
        
//        ArcballCamera *camera = [ArcballCamera new];
//        camera.transform.position = simd_make_float3(0.f, 1.5f, -5.f);
//        camera.distance = simd_length(camera.transform.position);
//        camera.target = simd_make_float3(0.f, 1.2f, 0.f);
        
//        OrthographicCamera *camera = [OrthographicCamera new];
////        camera.transform.position = simd_make_float3(3.f, 2.f, 0.f);
////        camera.transform->_rotation.y = -M_PI_2;
//        camera.transform.position = simd_make_float3(0.f, 2.f, 0.f);
//        camera.transform->_rotation.y = M_PI_2;
        
        ChallengeCamera *camera = [ChallengeCamera new];
        camera.transform.position = simd_make_float3(0.f, 1.5f, -5.f);
        camera.distance = simd_length(camera.transform.position);
        camera.target = simd_make_float3(0.f, 1.2f, 0.f);
        
        self.house = house;
        self.ground = ground;
        self->_models = models;
        self->_camera = camera;
    }
    
    return self;
}

- (void)updateWithDeltaTime:(float)deltaTime {
    self.ground.transform.scale = 40.f;
//    self.camera.transform->_rotation.y = sinf(deltaTime);
    [self.camera updateWithDeltaTime:deltaTime];
    
    if ([InputController.sharedInstance.keysPressed containsObject:[NSNumber numberWithLong:GCKeyCodeKeyH]]) {
        NSLog(@"H key pressed");
    }
}

- (void)updateWithSize:(CGSize)size {
    [self.camera updateWithSize:size];
}

@end
