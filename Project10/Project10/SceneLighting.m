//
//  SceneLighting.m
//  Project10
//
//  Created by Jinwoo Kim on 5/10/23.
//

#import "SceneLighting.h"

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

- (instancetype)init {
    if (self = [super init]) {
        self->_lights = [NSMutableArray new];
        
        Light sunlight = SceneLighting.sunlight;
        Light *heap_sunlight = malloc(sizeof(Light));
        memcpy(heap_sunlight, &sunlight, sizeof(Light));
        [self.lights addObject:[NSValue valueWithPointer:heap_sunlight]];
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
