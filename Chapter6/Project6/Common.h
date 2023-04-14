//
//  Common.h
//  Project6
//
//  Created by Jinwoo Kim on 4/13/23.
//

#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} Uniforms;
