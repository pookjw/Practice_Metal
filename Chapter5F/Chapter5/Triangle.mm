//
//  Triangle.m
//  Chapter5
//
//  Created by Jinwoo Kim on 8/27/24.
//

#import "Triangle.h"
#include <ranges>

@implementation Triangle

- (instancetype)initWithDevice:(id<MTLDevice>)device scale:(float)scale {
    if (self = [super init]) {
        _vertices = std::vector<Vertex> {
            Vertex { -0.7, 0.8, 0 },
            Vertex { -0.7, -0.5, 0 },
            Vertex { 0.4, 0.1, 0 }
        } | std::views::transform([scale](Vertex vertex) {
            return Vertex { vertex.x * scale, vertex.y * scale, vertex.z * scale };
        }) | std::ranges::to<std::vector<Vertex>>();
        
        _indices = std::vector<std::uint16_t> { 0, 1, 2 };
        
        id<MTLBuffer> vertexBuffer = [device newBufferWithBytes:_vertices.data() length:sizeof(Vertex) * _vertices.size() options:0];
        id<MTLBuffer> indexBuffer = [device newBufferWithBytes:_indices.data() length:sizeof(std::uint16_t) * _indices.size() options:0];
        
        _vertexBuffer = [vertexBuffer retain];
        _indexBuffer = [indexBuffer retain];
        [vertexBuffer release];
        [indexBuffer release];
    }
    
    return self;
}

- (void)dealloc {
    [_vertexBuffer release];
    [_indexBuffer release];
    [super dealloc];
}

@end
