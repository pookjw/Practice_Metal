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
    
    [renderEncoder setRenderPipelineState:self.trianglePipelineState];
    [renderEncoder setVertexBuffer:self.triangle.vertexBuffer offset:0 atIndex:0];
    
    simd_float4 color = simd_make_float4(0.8f, 0.8f, 0.8f, 1.f);
    simd_float4x4 matrix = matrix_identity_float4x4;
    
    [renderEncoder setFragmentBytes:&color length:sizeof(simd_float4) atIndex:0];
    [renderEncoder setVertexBytes:&matrix length:sizeof(simd_float4x4) atIndex:11];
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:sizeof(self.triangle->indices) / sizeof(uint16_t)
                               indexType:MTLIndexTypeUInt16
                             indexBuffer:self.triangle.indexBuffer
                       indexBufferOffset:0];
    
    //
    
    color = simd_make_float4(1.f, 0.f, 0.f, 1.f);
    
    simd_float4x4 translation = matrix_identity_float4x4;
    translation.columns[3].x = 0.3f;
    translation.columns[3].y = -0.4f;
    translation.columns[3].z = 0.f;
    
    float angle = M_PI / 2.f;
    simd_float4x4 rotationMatrix = matrix_identity_float4x4;
    rotationMatrix.columns[0].x = cosf(angle);
    rotationMatrix.columns[0].y = -sinf(angle);
    rotationMatrix.columns[1].x = sinf(angle);
    rotationMatrix.columns[1].y = cosf(angle);
    
    simd_float4x4 scaleMatrix = matrix_identity_float4x4;
    scaleMatrix.columns[0].x = 1.2f;
    scaleMatrix.columns[1].y = 0.5f;
    
//    matrix = matrix_multiply(translation, scaleMatrix);
//    matrix = rotationMatrix;
    matrix = matrix_multiply(matrix_multiply(translation, rotationMatrix), scaleMatrix);
    
    [renderEncoder setFragmentBytes:&color length:sizeof(simd_float4) atIndex:0];
    [renderEncoder setVertexBytes:&matrix length:sizeof(simd_float4x4) atIndex:11];
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:sizeof(self.triangle->indices) / sizeof(uint16_t)
                               indexType:MTLIndexTypeUInt16
                             indexBuffer:self.triangle.indexBuffer
                       indexBufferOffset:0];
    
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
    
    [renderEncoder endEncoding];
    id<CAMetalDrawable> drawable = [view currentDrawable];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
