//
//  Transform.m
//  Project6
//
//  Created by Jinwoo Kim on 4/14/23.
//

#import "Transform.h"
#import "MathLibrary.h"

@implementation Transform

- (instancetype)init {
    if (self = [super init]) {
        self.scale = 1.f;
    }
    
    return self;
}

- (matrix_float4x4)modelMatrix {
    simd_float4x4 translation = [MathLibrary float4x4FromTranslation:self.position];
    simd_float4x4 rotation = [MathLibrary float4x4FromFloat3RotationAngle:self.rotation];
    simd_float4x4 scale = [MathLibrary float4x4FromFloatScale:self.scale];
    simd_float4x4 modelMatrix = matrix_multiply(matrix_multiply(translation, rotation), scale);
    return modelMatrix;
}

@end
