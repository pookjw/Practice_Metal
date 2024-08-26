//
//  Quad.m
//  Chapter4
//
//  Created by Jinwoo Kim on 8/26/24.
//

#import "Quad.h"
#include <ranges>

@implementation Quad

- (instancetype)initWithDevice:(id<MTLDevice>)device scale:(float)scale {
    if (self = [super init]) {
        _vertices = std::vector<Vertex> {
            Vertex {-1, 1, 0},
            Vertex {1, -1, 0},
            Vertex {-1, -1, 0},
            Vertex {-1, 1, 0},
            Vertex {1, 1, 0},
            Vertex {1, -1, 0}
        } |
        std::views::transform([scale](Vertex vertex) {
            return Vertex { vertex.x * scale, vertex.y * scale, vertex.z * scale};
        }) |
        std::ranges::to<std::vector<Vertex>>();
        
        //
        
        id<MTLBuffer> vertexBuffer = [device newBufferWithBytes:_vertices.data() length:sizeof(Vertex) * _vertices.size() options:0];
        
        _vertexBuffer = [vertexBuffer retain];
        [vertexBuffer release];
    }
    
    return self;
}

- (void)dealloc {
    [_vertexBuffer release];
    [super dealloc];
}

@end
