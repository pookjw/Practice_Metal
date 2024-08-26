//
//  Grid.m
//  Chapter5
//
//  Created by Jinwoo Kim on 4/8/23.
//

#import "Grid.h"

@implementation Grid

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    if (self = [self init]) {
        float unit = 1.f / GRID_BLOCK_COUNT;
        
        for (NSUInteger i = 0; i < (GRID_BLOCK_COUNT - 1) * 2; i = i + 2) {
            float coord = -1.f + unit * (float)(i + 2);
            coords[i] = simd_make_float3(-1.f, coord, 0.f);
            coords[i + 1] = simd_make_float3(1.f, coord, 0.f);
            coords[i + (GRID_BLOCK_COUNT - 1) * 2] = simd_make_float3(coord, -1.f, 0.f);
            coords[i + (GRID_BLOCK_COUNT - 1) * 2 + 1] = simd_make_float3(coord, 1.f, 0.f);
        }
        
        for (NSUInteger i = 0; i < (GRID_BLOCK_COUNT - 1) * 4; i++) {
            indices[i] = i;
        }
        
        _coordsBuffer = [device newBufferWithBytes:coords length:sizeof(coords) options:0];
        _indicesBuffer = [device newBufferWithBytes:indices length:sizeof(indices) options:0];
    }
    
    return self;
}

@end
