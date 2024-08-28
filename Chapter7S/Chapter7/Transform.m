//
//  Transform.m
//  Chapter6
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import "Transform.h"
#import "MathLibrary.h"

@implementation Transform

- (instancetype)init {
    if (self = [super init]) {
        _position = simd_make_float3(0.f, 0.f, 0.f);
        _rotation = simd_make_float3(0.f, 0.f, 0.f);
        _scale = 1.f;
    }
    return self;
}

- (simd_float4x4)modelMatrix {
    simd_float4x4 translation = [MathLibrary float4x4FromFloat3Translation:_position];
    simd_float4x4 rotation = [MathLibrary float4x4FromRotationXYZAngle:_rotation];
    simd_float4x4 scale = [MathLibrary float4x4FromScale:_scale];
    
    simd_float4x4 modelMatrix = simd_mul(translation, simd_mul(rotation, scale));
    return modelMatrix;
}

@end
