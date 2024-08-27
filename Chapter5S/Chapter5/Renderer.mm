//
//  Renderer.m
//  Chapter5
//
//  Created by Jinwoo Kim on 8/27/24.
//

#import "Renderer.h"
#import "MTLVertexDescriptor+DefaultLayout.h"
#import "Triangle.h"
#import "Grid.h"

@interface Renderer () <MTKViewDelegate>
@property (retain, nonatomic) MTKView *metalView;
@property (retain, nonatomic) id<MTLDevice> device;
@property (retain, nonatomic) id<MTLCommandQueue> commandQueue;
@property (retain, nonatomic) id<MTLRenderPipelineState> pipelineState;
@property (retain, nonatomic) id<MTLRenderPipelineState> gridPipelineState;
@property (retain, nonatomic) Triangle *triangle;
@property (retain, nonatomic) Grid *grid;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView {
    if (self = [super init]) {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        
        //
        
        metalView.device = device;
        metalView.delegate = self;
        metalView.depthStencilPixelFormat = MTLPixelFormatInvalid;
        metalView.clearColor = MTLClearColorMake(1.0, 1.0, 0.9, 1.0);
        
        //
        
        id<MTLLibrary> library = [device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_main"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
        id<MTLFunction> vertexGridFunction = [library newFunctionWithName:@"vertex_grid_main"];
        id<MTLFunction> fragmentGridFunction = [library newFunctionWithName:@"fragment_grid_main"];
        
        [library release];
        
        //
        
        MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
        pipelineDescriptor.vertexFunction = vertexFunction;
        [vertexFunction release];
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        [fragmentFunction release];
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
        pipelineDescriptor.vertexDescriptor = [MTLVertexDescriptor defaultLayout];
        
        NSError * _Nullable error = nil;
        id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        [pipelineDescriptor release];
        assert(error == nil);
        
        //
        
        MTLRenderPipelineDescriptor *gridPiplineDescriptor = [MTLRenderPipelineDescriptor new];
        gridPiplineDescriptor.vertexFunction = vertexGridFunction;
        [vertexGridFunction release];
        gridPiplineDescriptor.fragmentFunction = fragmentGridFunction;
        [fragmentGridFunction release];
        gridPiplineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
        gridPiplineDescriptor.vertexDescriptor = [MTLVertexDescriptor defaultLayout];
        
        id<MTLRenderPipelineState> gridPipelineState = [device newRenderPipelineStateWithDescriptor:gridPiplineDescriptor error:&error];
        [gridPiplineDescriptor release];
        assert(error == nil);
        
        //
        
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        Triangle *triangle = [[Triangle alloc] initWithDevice:device scale:1.f];
        Grid *grid = [[Grid alloc] initWithDevice:device];
        
        //
        
        _showGrid = YES;
        self.metalView = metalView;
        self.device = device;
        self.commandQueue = commandQueue;
        self.pipelineState = pipelineState;
        self.gridPipelineState = gridPipelineState;
        self.triangle = triangle;
        self.grid = grid;
        
        [device release];
        [commandQueue release];
        [pipelineState release];
        [gridPipelineState release];
        [triangle release];
        [grid release];
    }
    
    return self;
}

- (void)dealloc {
    [_metalView release];
    [_device release];
    [_commandQueue release];
    [_pipelineState release];
    [_gridPipelineState release];
    [_triangle release];
    [_grid release];
    [super dealloc];
}

- (void)setShowGrid:(BOOL)showGrid {
    _showGrid = showGrid;
    [self _drawInMTKView:self.metalView];
}

- (void)_drawInMTKView:(MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *descriptor = [view currentRenderPassDescriptor];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    //
    
    if (self.showGrid) {
        [renderEncoder setRenderPipelineState:self.gridPipelineState];
        [renderEncoder setVertexBuffer:self.grid.vertexBuffer offset:0 atIndex:0];
        [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeLine
                                  indexCount:self.grid.indices.size()
                                   indexType:MTLIndexTypeUInt16
                                 indexBuffer:self.grid.indexBuffer
                           indexBufferOffset:0];
    }
    
    //
    
    [renderEncoder setRenderPipelineState:self.pipelineState];
    [renderEncoder setVertexBuffer:self.triangle.vertexBuffer offset:0 atIndex:0];
    
    // draw the untransformed triangle in light gray
    simd_float4 color = {0.8, 0.8, 0.8, 1.0};
    [renderEncoder setFragmentBytes:&color length:sizeof(simd_float4) atIndex:0];
    
    simd_float3 position = {0, 0, 0};
    [renderEncoder setVertexBytes:&position length:sizeof(simd_float3) atIndex:11];
    
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:self.triangle.indices.size()
                               indexType:MTLIndexTypeUInt16
                             indexBuffer:self.triangle.indexBuffer
                       indexBufferOffset:0];
    
    // draw the new triangle in red
    color = {1, 0, 0, 1};
    [renderEncoder setFragmentBytes:&color length:sizeof(simd_float4) atIndex:0];
    
    position = {0.3, -0.4, 0};
    [renderEncoder setVertexBytes:&position length:sizeof(simd_float3) atIndex:11];
    
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:self.triangle.indices.size()
                               indexType:MTLIndexTypeUInt16
                             indexBuffer:self.triangle.indexBuffer
                       indexBufferOffset:0];
    
    //
    
    [renderEncoder endEncoding];
    [commandBuffer presentDrawable:[view currentDrawable]];
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    [self _drawInMTKView:view];
}

- (void)drawInMTKView:(MTKView *)view {
    
}

@end
