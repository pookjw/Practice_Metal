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

@property (strong) id<MTLDevice> device;
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
        
        self.device = device;
        self.commandQueue = commandQueue;
        self.library = library;
        self.pipelineState = pipelineState;
        self.depthStencilState = depthStencilState;
    }
    
    return self;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

// TODO

@end
