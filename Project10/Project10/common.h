//
//  common.h
//  Project10
//
//  Created by Jinwoo Kim on 5/7/23.
//

#ifndef common_h
#define common_h

#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} Uniforms;

typedef struct {
    uint width;
    uint height;
    uint tiling;
} Params;

typedef enum {
    Position = 0,
    Normal = 1,
    UV = 2,
    Color = 3
} Attributes;

typedef enum {
    VertexBuffer = 0,
    UVBuffer = 1,
    ColorBuffer = 2,
    UniformsBuffer = 11,
    ParamsBuffer = 12
} BufferIndices;

typedef enum {
    BaseColor = 0
} TextureIndices;

#endif /* common_h */
