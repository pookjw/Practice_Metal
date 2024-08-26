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
            Vertex {1, 1, 0},
            Vertex {-1, -1, 0},
            Vertex {1, -1, 0}
        } |
        std::views::transform([scale](Vertex vertex) {
            return Vertex { vertex.x * scale, vertex.y * scale, vertex.z * scale};
        }) |
        std::ranges::to<std::vector<Vertex>>();
        
        _indices = std::vector<std::uint16_t> {
            0, 3, 2,
            0, 1, 3
        };
        
        _colors = std::vector<simd_float3> {
            simd_make_float3(1, 0, 0),
            simd_make_float3(0, 1, 0),
            simd_make_float3(0, 0, 1),
            simd_make_float3(1, 1, 0)
        };
        
        //
        
        id<MTLBuffer> vertexBuffer = [device newBufferWithBytes:_vertices.data() length:sizeof(Vertex) * _vertices.size() options:0];
        id<MTLBuffer> indexBuffer = [device newBufferWithBytes:_indices.data() length:sizeof(std::uint16_t) * _indices.size() options:0];
        id<MTLBuffer> colorBuffer = [device newBufferWithBytes:_colors.data() length:sizeof(simd_float3) * _colors.size() options:0];
        
        _vertexBuffer = [vertexBuffer retain];
        _indexBuffer = [indexBuffer retain];
        _colorBuffer = [colorBuffer retain];
        
        [vertexBuffer release];
        [indexBuffer release];
        [colorBuffer release];
    }
    
    return self;
}

- (void)dealloc {
    [_vertexBuffer release];
    [_indexBuffer release];
    [super dealloc];
}

@end
