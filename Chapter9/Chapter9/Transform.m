//
//  Transform.m
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import "Transform.h"
#import "MathLibrary.h"

@implementation Transform

- (instancetype)init {
    if (self = [super init]) {
        _scale = 1.f;
    }
    
    return self;
}

- (matrix_float4x4)modelMatrix {
    simd_float4x4 translation = [MathLibrary float4x4FromFloat3Translation:_position];
    simd_float4x4 rotation = [MathLibrary float4x4FromRotationXYZAngle:_rotation];
    simd_float4x4 scale = [MathLibrary float4x4FromScale:_scale];
    
    return simd_mul(simd_mul(translation, rotation), scale);
}

@end
