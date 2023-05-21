//
//  SceneLighting.m
//  Project10
//
//  Created by Jinwoo Kim on 5/10/23.
//

#import "SceneLighting.h"
#import "MathLibrary.h"

@implementation SceneLighting

+ (Light)buildDefaultLight {
    Light light = {
        .position = simd_make_float3(0.f, 0.f, 0.f),
        .color = simd_make_float3(1.f, 1.f, 1.f),
        .specularColor = simd_make_float3(0.6f, 0.6f, 0.6f),
        .attenutation = simd_make_float3(1.f, 0.f, 0.f),
        .type = Sun
    };
    
    return light;
}

+ (Light)sunlight {
    Light light = [self buildDefaultLight];
    light.position = simd_make_float3(1.f, 2.f, -2.f);
    return light;
}

+ (Light)ambientLight {
    Light ambientLight = [self buildDefaultLight];
    ambientLight.color = simd_make_float3(0.05f, 0.1f, 0.f);
    ambientLight.type = Ambient;
    return ambientLight;
}

+ (Light)redLight {
    Light redLight = [self buildDefaultLight];
    redLight.type = _Point;
    redLight.position = simd_make_float3(-0.8f, 0.76f, -0.18f);
    redLight.color = simd_make_float3(1.f, 0.f, 0.f);
    redLight.attenutation = simd_make_float3(0.5f, 2.f, 1.f);
    return redLight;
}

+ (Light)spotLight {
    Light spotLight = [self buildDefaultLight];
    spotLight.type = Spot;
    spotLight.position = simd_make_float3(-0.64f, 0.64f, -1.07f);
    spotLight.color = simd_make_float3(1.f, 0.f, 1.f);
    spotLight.attenutation = simd_make_float3(1.f, 0.5f, 0.f);
    spotLight.coneAngle = [MathLibrary radiansFromDegrees:40.f];
    spotLight.coneDirection = simd_make_float3(0.5f, -0.7f, 1.f);
    spotLight.coneAttenuation = 8.f;
    return spotLight;
}

- (instancetype)init {
    if (self = [super init]) {
        self->_lights = [NSMutableArray new];
        
        Light sunlight = SceneLighting.sunlight;
        Light *heap_sunlight = malloc(sizeof(Light));
        memcpy(heap_sunlight, &sunlight, sizeof(Light));
        
        Light ambientLight = SceneLighting.ambientLight;
        Light *heap_ambientLight = malloc(sizeof(Light));
        memcpy(heap_ambientLight, &ambientLight, sizeof(Light));
        
        Light redLight = SceneLighting.redLight;
        Light *heap_redLight = malloc(sizeof(Light));
        memcpy(heap_redLight, &redLight, sizeof(Light));
        
        Light spotLight = SceneLighting.spotLight;
        Light *heap_spotLight = malloc(sizeof(Light));
        memcpy(heap_spotLight, &spotLight, sizeof(Light));
        
        [self.lights addObjectsFromArray:@[
            [NSValue valueWithPointer:heap_sunlight],
            [NSValue valueWithPointer:heap_ambientLight],
            [NSValue valueWithPointer:heap_redLight],
            [NSValue valueWithPointer:heap_spotLight]
        ]];
    }
    
    return self;
}

- (void)dealloc {
    [self.lights enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        free(obj.pointerValue);
    }];
}

- (Light *)lightsDataWithCount:(NSUInteger *)count {
    Light *lightsData = malloc(sizeof(Light) * self.lights.count);
    
    for (NSUInteger i = 0; i < self.lights.count; i++) {
        lightsData[i] = *((Light *)self.lights[i].pointerValue);
    }
    
    *count = self.lights.count;
    
    return lightsData;
}

@end
