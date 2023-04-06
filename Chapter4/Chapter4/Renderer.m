//
//  Renderer.m
//  Chapter4
//
//  Created by Jinwoo Kim on 4/7/23.
//

#import "Renderer.h"
#import "Quad.h"

@interface Renderer () <MTKViewDelegate>
@property (strong) id<MTLDevice> device;
@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id<MTLLibrary> library;
@property (strong) id<MTLRenderPipelineState> pipelineState;

@property (strong) Quad *quad;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView {
    if (self = [self init]) {
        metalView.clearColor = MTLClearColorMake(1.0, 1.0, 0.8, 1.0);
        metalView.delegate = self;
        
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        id<MTLLibrary> library = [device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_main"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
        
        MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
        pipelineDescriptor.vertexFunction = vertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
        
        NSError * _Nullable error = nil;
        id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        NSAssert((error == nil), error.localizedDescription);
        
        Quad *quad = [[Quad alloc] initWithDevice:device scale:0.8f];
        
        metalView.device = device;
        self.device = device;
        self.commandQueue = commandQueue;
        self.library = library;
        self.pipelineState = pipelineState;
        self.quad = quad;
    }
    
    return self;
}

- (void)drawInMTKView:(nonnull MTKView *)view { 
    
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size { 
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *descriptor = [view currentRenderPassDescriptor];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    [renderEncoder setRenderPipelineState:self.pipelineState];
    
    //
    
    [renderEncoder setVertexBuffer:self.quad.vertexBuffer offset:0 atIndex:0];
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                      vertexStart:0 
                      vertexCount:self.quad.count];
    
    //
    
    [renderEncoder endEncoding];
    id<MTLDrawable> drawable = view.currentDrawable;
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
