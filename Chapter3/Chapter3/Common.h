//
//  Common.h
//  Chapter3
//
//  Created by Jinwoo Kim on 7/18/22.
//

#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} Uniforms;
