//
//  Renderer.m
//  Chapter8
//
//  Created by Jinwoo Kim on 4/29/23.
//

#import "Renderer.h"
#import "Common.h"
#import "Model.h"
#import "MTLVertexDescriptor+Category.h"
#import "MathLibrary.h"

@interface Renderer () <MTKViewDelegate>
@property (strong) id<MTLDevice> device;
@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id<MTLLibrary> library;

@property (strong) id<MTLRenderPipelineState> pipelineState;
@property (strong) id<MTLDepthStencilState> depthStencilState;

@property (assign) float timer;
@property (assign) RendererChoice choice;

@property (assign) Uniforms uniforms;
@property (assign) Params params;

@property (strong) Model *house;
@property (strong) Model *ground;
@end

@implementation Renderer

+ (id<MTLDepthStencilState>)buildDepthStencilStateWithDevice:(id<MTLDevice>)device {
    MTLDepthStencilDescriptor *descriptor = [MTLDepthStencilDescriptor new];
    descriptor.depthCompareFunction = MTLCompareFunctionLess;
    descriptor.depthWriteEnabled = YES;
    return [device newDepthStencilStateWithDescriptor:descriptor];
}

- (instancetype)initWithMTKView:(MTKView *)mtkView choice:(RendererChoice)choice {
    if (self = [self init]) {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        
        mtkView.device = device;
        mtkView.delegate = self;
        mtkView.clearColor = MTLClearColorMake(0.93f, 0.97f, 1.f, 1.f);
        mtkView.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
        
        id<MTLLibrary> library = [device newDefaultLibrary];
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
        NSAssert((error == nil), error.localizedDescription);
        
        id<MTLDepthStencilState> depthStencilState = [self.class buildDepthStencilStateWithDevice:device];
        
        self.device = device;
        self.commandQueue = commandQueue;
        self.library = library;
        self.pipelineState = pipelineState;
        self.depthStencilState = depthStencilState;
        self.choice = choice;
        self.house = [[Model alloc] initWithName:@"lowpoly-house.obj" device:device];
        self.ground = [[Model alloc] initWithName:@"plane.obj" device:device];
        self.ground.tiling = 16.f;
        
        [self mtkView:mtkView drawableSizeWillChange:mtkView.bounds.size];
    }
    
    return self;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size { 
    CGFloat aspect = view.bounds.size.width / view.bounds.size.height;
    simd_float4x4 projectionMatrix = [MathLibrary float4x4FromProjectionFov:[MathLibrary radiansFromDegrees:70.f]
                                                                       near:0.1f
                                                                        far:100.f
                                                                     aspect:aspect];
    
    self->_uniforms.projectionMatrix = projectionMatrix;
    self->_params.width = size.width;
    self->_params.height = size.height;
}


- (void)drawInMTKView:(nonnull MTKView *)view { 
    id<MTLCommandBuffer> commandBuffer = self.commandQueue.commandBuffer;
    MTLRenderPassDescriptor *descriptor = view.currentRenderPassDescriptor;
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    assert(renderEncoder);
    
    self.timer += 0.005f;
    self->_uniforms.viewMatrix = simd_inverse([MathLibrary float4x4FromTranslation:simd_make_float3(0.f, 1.5f, -5.f)]);
    
    [renderEncoder setDepthStencilState:self.depthStencilState];
    [renderEncoder setRenderPipelineState:self.pipelineState];
    
    self.house.transform->_rotation.y = sinf(self.timer);
    [self.house renderInEncoder:renderEncoder uniforms:self.uniforms params:self.params];
    
    self.ground.transform.scale = 40.f;
    self.ground.transform->_rotation.y = sinf(self.timer);
    [self.ground renderInEncoder:renderEncoder uniforms:self.uniforms params:self.params];
    
    [renderEncoder endEncoding];
    id<MTLDrawable> drawable = view.currentDrawable;
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
