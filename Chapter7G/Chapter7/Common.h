//
//  Common.h
//  Chapter7
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} Uniforms;

typedef struct {
    uint width;
    uint height;
} Params;
