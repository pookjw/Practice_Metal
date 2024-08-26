//
//  Renderer.m
//  Chapter4
//
//  Created by Jinwoo Kim on 8/26/24.
//

#import "Renderer.h"
#import "Quad.h"

@interface Renderer () <MTKViewDelegate>
@property (retain, nonatomic, nullable) id<MTLDevice> device;
@property (retain, nonatomic, nullable) id<MTLCommandQueue> commandQueue;
@property (retain, nonatomic, nullable) id<MTLLibrary> library;
@property (retain, nonatomic, nullable) id<MTLRenderPipelineState> pipelineState;
@property (retain, nonatomic, nullable) Quad *quad;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView {
    if (self = [super init]) {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        
        //
        
        metalView.delegate = self;
        metalView.device = device;
        metalView.depthStencilPixelFormat = MTLPixelFormatInvalid;
        metalView.clearColor = MTLClearColorMake(1.0, 1.0, 0.8, 1.0);
        
        //
        
        id<MTLLibrary> library = [device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_main"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
        
        MTLRenderPipelineDescriptor *piplineDescriptor = [MTLRenderPipelineDescriptor new];
        piplineDescriptor.vertexFunction = vertexFunction;
        [vertexFunction release];
        piplineDescriptor.fragmentFunction = fragmentFunction;
        [fragmentFunction release];
        piplineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
        
        NSError * _Nullable error = nil;
        id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:piplineDescriptor error:&error];
        [piplineDescriptor release];
        assert(error == nil);
        
        //
        
        Quad *quad = [[Quad alloc] initWithDevice:device scale:0.8f];
        
        //
        
        self.device = device;
        self.commandQueue = commandQueue;
        self.library = library;
        self.pipelineState = pipelineState;
        self.quad = quad;
        
        [device release];
        [commandQueue release];
        [library release];
        [pipelineState release];
        [quad release];
    }
    
    return self;
}

- (void)dealloc {
    [_device release];
    [_commandQueue release];
    [_library release];
    [_pipelineState release];
    [super dealloc];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

- (void)drawInMTKView:(MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *descriptor = [view currentRenderPassDescriptor];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    [renderEncoder setRenderPipelineState:self.pipelineState];
    
    [renderEncoder setVertexBuffer:self.quad.vertexBuffer offset:0 atIndex:0];
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:self.quad.vertices.size()];
    
    [renderEncoder endEncoding];
    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

@end
