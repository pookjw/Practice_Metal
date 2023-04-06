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
        const float vertices[18] = {
            -1, 1, 0,
            1, -1, 0,
            -1, -1, 0,
            -1, 1, 0,
            1, 1, 0,
            1, -1, 0
        };
        
        _vertices = malloc(sizeof(vertices));
        _count = sizeof(vertices) / __SIZEOF_FLOAT__;
        
        memcpy(_vertices, vertices, sizeof(vertices));
        
        for (NSUInteger index = 0; index < _count; index++) {
            _vertices[index] *= scale;
        }
        
        id<MTLBuffer> _Nullable vertexBuffer = [device newBufferWithBytes:_vertices length:__SIZEOF_FLOAT__ * _count options:0];
        assert(vertexBuffer);
        self->_vertexBuffer = vertexBuffer;
    }
    
    return self;
}

- (void)dealloc {
    free(_vertices);
}

@end
