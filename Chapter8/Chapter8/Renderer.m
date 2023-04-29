//
//  Renderer.m
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import "Renderer.h"
#import "Common.h"

@interface Renderer ()
@property (strong) id<MTLDevice> device;
@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id<MTLLibrary> library;

@property (strong) id<MTLRenderPipelineState> pipelineState;
@property (strong) id<MTLDepthStencilState> depthStencilState;

@property (assign) float timer;
@property (assign) RendererChoice choice;

@property (assign) Uniforms uniforms;
@property (assign) Params params;
@end

@implementation Renderer

- (instancetype)initWithMTKView:(MTKView *)mtkView choice:(RendererChoice)choice {
    if (self = [self init]) {
        
    }
    
    return self;
}

@end
