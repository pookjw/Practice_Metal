//
//  Renderer.m
//  Chapter5
//
//  Created by Jinwoo Kim on 4/8/23.
//

#import "Renderer.h"
#import "Triangle.h"
#import "Grid.h"

@interface Renderer () <MTKViewDelegate>
@property (strong) id<MTLDevice> device;
@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id<MTLRenderPipelineState> gridPipelineState;
@property (strong) id<MTLRenderPipelineState> trianglePipelineState;

@property (strong) Triangle *triangle;
@property (strong) Grid *grid;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView {
    if (self = [self init]) {
        metalView.delegate = self;
        metalView.clearColor = MTLClearColorMake(1.f, 1.f, 0.9f, 1.f);
        
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        
        //
        
        id<MTLLibrary> library = [device newDefaultLibrary];
        
        MTLRenderPipelineDescriptor *gridPipelineDescriptor = [MTLRenderPipelineDescriptor new];
        gridPipelineDescriptor.vertexFunction = [library newFunctionWithName:@"grid_vertex_main"];
        gridPipelineDescriptor.fragmentFunction = [library newFunctionWithName:@"grid_fragment_main"];
        gridPipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
        
        MTLVertexDescriptor *gridVertexDescriptor = [MTLVertexDescriptor new];
        gridVertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
        gridVertexDescriptor.attributes[0].offset = 0;
        gridVertexDescriptor.attributes[0].bufferIndex = 0;
        gridVertexDescriptor.layouts[0].stride = sizeof(simd_float3);
        gridPipelineDescriptor.vertexDescriptor = gridVertexDescriptor;
        
        id<MTLRenderPipelineState> gridPipelineState = [device newRenderPipelineStateWithDescriptor:gridPipelineDescriptor error:nil];
        assert(gridPipelineState);
        
        //
        
        MTLRenderPipelineDescriptor *trianglePipelineDescriptor = [MTLRenderPipelineDescriptor new];
        trianglePipelineDescriptor.vertexFunction = [library newFunctionWithName:@"triangle_vertex_main"];
        trianglePipelineDescriptor.fragmentFunction = [library newFunctionWithName:@"triangle_fragment_main"];
        trianglePipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
        
        MTLVertexDescriptor *triangleVertexDescriptor = [MTLVertexDescriptor new];
        triangleVertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
        triangleVertexDescriptor.attributes[0].offset = 0;
        triangleVertexDescriptor.attributes[0].bufferIndex = 0;
        triangleVertexDescriptor.layouts[0].stride = __SIZEOF_FLOAT__ * 3;
        
        trianglePipelineDescriptor.vertexDescriptor = triangleVertexDescriptor;
        
        id<MTLRenderPipelineState> trianglePipelineState = [device newRenderPipelineStateWithDescriptor:trianglePipelineDescriptor error:nil];
        assert(trianglePipelineState);
        
        //
        
        metalView.device = device;
        
        self.device = device;
        self.commandQueue = commandQueue;
        self.gridPipelineState = gridPipelineState;
        self.trianglePipelineState = trianglePipelineState;
        self.triangle = [[Triangle alloc] initWithDevice:device];
        self.grid = [[Grid alloc] initWithDevice:device];
    }
    
    return self;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size { 
    
}

- (void)drawInMTKView:(nonnull MTKView *)view { 
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *descriptor = [view currentRenderPassDescriptor];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    //
    
    [renderEncoder setRenderPipelineState:self.gridPipelineState];
    [renderEncoder setVertexBuffer:self.grid.coordsBuffer offset:0 atIndex:0];
    
    for (NSUInteger i = 0; i < (GRID_BLOCK_COUNT - 1) * 2; i++) {
        @autoreleasepool {
            [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeLine
                                      indexCount:2
                                       indexType:MTLIndexTypeUInt16
                                     indexBuffer:self.grid.indicesBuffer
                               indexBufferOffset:sizeof(ushort) * i * 2];
        }
    }
    
    //
    
    [renderEncoder setRenderPipelineState:self.trianglePipelineState];
    [renderEncoder setVertexBuffer:self.triangle.vertexBuffer offset:0 atIndex:0];
    
    simd_float4 color = simd_make_float4(0.8f, 0.8f, 0.8f, 1.f);
    simd_float3 position = simd_make_float3(0.f, 0.f, 0.f);
    
    [renderEncoder setFragmentBytes:&color length:sizeof(simd_float4) atIndex:0];
    [renderEncoder setVertexBytes:&position length:sizeof(simd_float3) atIndex:11];
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:sizeof(self.triangle->indices) / sizeof(uint16_t)
                               indexType:MTLIndexTypeUInt16
                             indexBuffer:self.triangle.indexBuffer
                       indexBufferOffset:0];
    
    color = simd_make_float4(1.f, 0.f, 0.f, 1.f);
    position = simd_make_float3(0.3f, -0.4f, 0.f);
    
    [renderEncoder setFragmentBytes:&color length:sizeof(simd_float4) atIndex:0];
    [renderEncoder setVertexBytes:&position length:sizeof(simd_float3) atIndex:11];
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:sizeof(self.triangle->indices) / sizeof(uint16_t)
                               indexType:MTLIndexTypeUInt16
                             indexBuffer:self.triangle.indexBuffer
                       indexBufferOffset:0];
    
    //
    
    [renderEncoder endEncoding];
    id<CAMetalDrawable> drawable = [view currentDrawable];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
