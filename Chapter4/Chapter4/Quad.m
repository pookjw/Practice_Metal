//
//  Quad.m
//  Chapter4
//
//  Created by Jinwoo Kim on 4/7/23.
//

#import "Quad.h"

@implementation Quad

- (instancetype)initWithDevice:(id<MTLDevice>)device scale:(float)scale {
    if (self = [self init]) {
        const float vertices[12] = {
            -1, 1, 0,
            1, 1, 0,
            -1, -1, 0,
            1, -1, 0
        };
        
        _vertices = malloc(sizeof(vertices));
        _verticesCount = sizeof(vertices) / __SIZEOF_FLOAT__;
        
        memcpy(_vertices, vertices, sizeof(vertices));
        
        const ushort indices[6] = {
            0, 3, 2,
            0, 1, 3
        };
        
        _indices = malloc(sizeof(indices));
        _indicesCount = sizeof(indices) / __SIZEOF_SHORT__;
        
        memcpy(_indices, indices, sizeof(indices));
        
        const simd_float3 colors[] = {
            simd_make_float3(1.f, 0.f, 0.f), // red
            simd_make_float3(0.f, 1.f, 0.f), // green
            simd_make_float3(0.f, 0.f, 1.f), // blue
            simd_make_float3(1.f, 1.f, 0.f) // yellow
        };
        
        _colors = malloc(sizeof(colors));
        _colorsCount = sizeof(colors) / sizeof(simd_float3);
        
        memcpy(_colors, colors, sizeof(colors));
        
        for (NSUInteger index = 0; index < _verticesCount; index++) {
            _vertices[index] *= scale;
        }
        
        id<MTLBuffer> _Nullable vertexBuffer = [device newBufferWithBytes:_vertices length:__SIZEOF_FLOAT__ * _verticesCount options:0];
        assert(vertexBuffer);
        _vertexBuffer = vertexBuffer;
        
        id<MTLBuffer> _Nullable indexBuffer = [device newBufferWithBytes:_indices length:__SIZEOF_SHORT__ * _indicesCount options:0];
        assert(indexBuffer);
        _indexBuffer = indexBuffer;
        
        id<MTLBuffer> _Nullable colorBuffer = [device newBufferWithBytes:_colors length:sizeof(simd_float3) * _colorsCount options:0];
        assert(colorBuffer);
        _colorBuffer = colorBuffer;
    }
    
    return self;
}

- (void)dealloc {
    free(_vertices);
    free(_indices);
    free(_colors);
}

@end
