//
//  Triangle.m
//  Chapter5
//
//  Created by Jinwoo Kim on 4/8/23.
//

#import "Triangle.h"

@implementation Triangle

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    if (self = [self init]) {
        const float _vertices[] = {
            -0.7f, 0.8f, 0.f,
            -0.7f, -0.5f, 0.f,
            0.4f, 0.1f, 0.f
        };
        
        memcpy(vertices, _vertices, sizeof(vertices));
        
        const uint16_t _indices[] = {
            0, 1, 2
        };
        
        memcpy(indices, _indices, sizeof(indices));
        
        self->_vertexBuffer = [device newBufferWithBytes:vertices length:sizeof(vertices) options:0];
        self->_indexBuffer = [device newBufferWithBytes:indices length:sizeof(indices) options:0];
    }
    
    return self;
}

@end
