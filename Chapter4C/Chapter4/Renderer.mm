//
//  Renderer.m
//  Chapter4
//
//  Created by Jinwoo Kim on 8/26/24.
//

#import "Renderer.h"

@interface Renderer () <MTKViewDelegate>
@property (retain, nonatomic, nullable) id<MTLDevice> device;
@property (retain, nonatomic, nullable) id<MTLCommandQueue> commandQueue;
@property (retain, nonatomic, nullable) id<MTLLibrary> library;
@property (retain, nonatomic, nullable) id<MTLRenderPipelineState> pipelineState;
@property (assign, nonatomic) float timer;
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
        metalView.clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);
        
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
        
        self.device = device;
        self.commandQueue = commandQueue;
        self.library = library;
        self.pipelineState = pipelineState;
        
        [device release];
        [commandQueue release];
        [library release];
        [pipelineState release];
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
    
    _timer += 0.005f;
    float currentTime = sin(_timer);
    [renderEncoder setVertexBytes:&currentTime length:sizeof(float) atIndex:11];
    
    std::uint16_t count = 100;
    [renderEncoder setVertexBytes:&count length:sizeof(std::uint16_t) atIndex:0];
    
    [renderEncoder setRenderPipelineState:self.pipelineState];
    
    [renderEncoder drawPrimitives:MTLPrimitiveTypePoint vertexStart:0 vertexCount:count];
    
    [renderEncoder endEncoding];
    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

@end
