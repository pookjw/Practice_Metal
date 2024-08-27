//
//  Grid.m
//  Chapter5
//
//  Created by Jinwoo Kim on 8/27/24.
//

#import "Grid.h"
#include <ranges>

@implementation Grid

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    if (self = [super init]) {
        const std::vector<Vertex> verticalVertices = std::views::iota(0, 38)
        | std::views::transform([](std::uint8_t num) -> Vertex {
            return Vertex {
                .x = -0.9f + (num / 2) * 0.1f,
                .y = (num % 2 == 0) ? 1.f : -1.f,
                .z = 0.f
            };
        }) | std::ranges::to<std::vector<Vertex>>();
        
        const std::vector<Vertex> horizontalVertices = std::views::iota(0, 38)
        | std::views::transform([](std::uint8_t num) -> Vertex {
            return Vertex {
                .x = (num % 2 == 0) ? 1.f : -1.f,
                .y = 0.9f - (num / 2) * 0.1f,
                .z = 0.f
            };
        }) | std::ranges::to<std::vector<Vertex>>();
        
        _vertices.insert(_vertices.cend(), verticalVertices.cbegin(), verticalVertices.cend());
        _vertices.insert(_vertices.cend(), horizontalVertices.cbegin(), horizontalVertices.cend());
        
        _indices = std::views::iota(0, 77) | std::ranges::to<std::vector<std::uint16_t>>();
        
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
