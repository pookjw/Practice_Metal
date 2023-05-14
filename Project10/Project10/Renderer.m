//
//  Renderer.m
//  Project10
//
//  Created by Jinwoo Kim on 5/7/23.
//

#import "Renderer.h"
#import "MTLVertexDescriptor+Category.h"
#import "common.h"

@interface Renderer () {
    Uniforms uniforms;
    Params params;
}
@property (strong) MTKView *mtkView;

@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id<MTLLibrary> library;
@property (strong) id<MTLRenderPipelineState> pipelineState;
@property (strong) id<MTLDepthStencilState> depthStencilState;
@end

@implementation Renderer

- (instancetype)initWithMTKView:(MTKView *)mtkView {
    if (self = [self init]) {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        id<MTLLibrary> library = [device newDefaultLibrary];
        assert(library);
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_main"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
        
        MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
        pipelineDescriptor.vertexFunction = vertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        pipelineDescriptor.depthAttachmentPixelFormat = MTLPixelFormatDepth32Float;
        pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout;
        
        NSError * _Nullable error = nil;
        id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        NSAssert(!error, error.localizedDescription);
        
        MTLDepthStencilDescriptor *depthStencilDesciptor = [MTLDepthStencilDescriptor new];
        depthStencilDesciptor.depthCompareFunction = MTLCompareFunctionLess;
        depthStencilDesciptor.depthWriteEnabled = YES;
        
        id<MTLDepthStencilState> depthStencilState = [device newDepthStencilStateWithDescriptor:depthStencilDesciptor];
        
        mtkView.device = device;
        mtkView.clearColor = MTLClearColorMake(0.93f, 0.97f, 1.f, 1.f);
        mtkView.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
        
        self->_device = device;
        self.commandQueue = commandQueue;
        self.library = library;
        self.pipelineState = pipelineState;
        self.depthStencilState = depthStencilState;
    }
    
    return self;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

- (void)drawInScene:(GameScene *)scene view:(MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = self.commandQueue.commandBuffer;
    MTLRenderPassDescriptor *descriptor = view.currentRenderPassDescriptor;
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    assert(renderEncoder);
    
    [self updateUniformsWithScene:scene];
    
    [renderEncoder setDepthStencilState:self.depthStencilState];
    [renderEncoder setRenderPipelineState:self.pipelineState];
    
    NSUInteger count;
    Light *lights = [scene.lighting lightsDataWithCount:&count];
    [renderEncoder setFragmentBytes:lights length:sizeof(Light) * count atIndex:LightBuffer];
    free(lights);
    
    [scene.models enumerateObjectsUsingBlock:^(Model * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj renderInEncoder:renderEncoder uniforms:self->uniforms params:self->params];
    }];
    
    [renderEncoder endEncoding];
    
    id<CAMetalDrawable> drawable = view.currentDrawable;
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

- (void)updateUniformsWithScene:(GameScene *)scene {
    self->uniforms.viewMatrix = scene.camera.viewMatrix;
    self->uniforms.projectionMatrix = scene.camera.projectionMatrix;
    self->params.lightCount = (uint)scene.lighting.lights.count;
}

@end
