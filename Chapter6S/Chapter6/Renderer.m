//
//  Renderer.m
//  Chapter6
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import "Renderer.h"
#import "MTLVertexDescriptor+DefaultLayout.h"
#import "Model.h"

@interface Renderer () <MTKViewDelegate>
@property (retain, readonly, nonatomic) id<MTLDevice> device;
@property (retain, readonly, nonatomic) id<MTLCommandQueue> commandQueue;
@property (retain, readonly, nonatomic) id<MTLRenderPipelineState> pipelineState;
@property (retain, readonly, nonatomic) Model *model;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView {
    if (self = [super init]) {
        metalView.delegate = self;
        metalView.clearColor = MTLClearColorMake(1.f, 1.f, 0.9f, 1.f);
        metalView.depthStencilPixelFormat = MTLPixelFormatInvalid;
        
        //
        
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        
        metalView.device = device;
        
        //
        
        id<MTLLibrary> library = [device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_main"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
        [library release];
        
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
        
        Model *model = [[Model alloc] initWithDevice:device name:@"train.usdz"];
        
        //
        
        _device = [device retain];
        _commandQueue = [commandQueue retain];
        _pipelineState = [pipelineState retain];
        _model = [model retain];
        
        [device release];
        [commandQueue release];
        [pipelineState release];
        [model release];
    }
    
    return self;
}

- (void)dealloc {
    [_device release];
    [_commandQueue release];
    [_pipelineState release];
    [_model release];
    [super dealloc];
}

- (void)_drawInMTKView:(MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *descriptor = [view currentRenderPassDescriptor];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    [renderEncoder setRenderPipelineState:self.pipelineState];
    [renderEncoder setTriangleFillMode:MTLTriangleFillModeLines];
    
    [self.model renderInEncoder:renderEncoder];
    
    [renderEncoder endEncoding];
    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    [self _drawInMTKView:view];
}

- (void)drawInMTKView:(MTKView *)view {
    
}

@end
