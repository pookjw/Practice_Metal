//
//  Renderer.m
//  Chapter6
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import "Renderer.h"
#import "MTLVertexDescriptor+DefaultLayout.h"
#import "Model.h"
#import "Common.h"
#import "MathLibrary.h"

@interface Renderer () <MTKViewDelegate>
@property (retain, readonly, nonatomic) id<MTLDevice> device;
@property (retain, readonly, nonatomic) id<MTLCommandQueue> commandQueue;
@property (retain, readonly, nonatomic) id<MTLRenderPipelineState> pipelineState;
@property (retain, readonly, nonatomic) Model *model;
@property (assign, nonatomic) Uniforms uniforms;
@property (assign, nonatomic) float timer;
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
        _timer = 0.f;
        
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
    [renderEncoder setTriangleFillMode:MTLTriangleFillModeFill];
    
    _uniforms.viewMatrix = simd_inverse([MathLibrary float4x4FromFloat3Translation:simd_make_float3(0.f, 0.f, -3.f)]);
    
    _timer += 0.005f;
    _model.transform->_position.y = -0.6f;
    _model.transform->_rotation.y = sin(_timer);
    _uniforms.modelMatrix = _model.transform.modelMatrix;
    
    [renderEncoder setVertexBytes:&_uniforms length:sizeof(Uniforms) atIndex:11];
    
    [self.model renderInEncoder:renderEncoder];
    
    [renderEncoder endEncoding];
    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    float aspect = size.width / size.height;
    simd_float4x4 projectionMatrix = [MathLibrary float4x4FromProjectionFov:[MathLibrary radiansFromDegrees:45.f] near:0.1f far:100.f aspect:aspect lhs:YES];
    _uniforms.projectionMatrix = projectionMatrix;
}

- (void)drawInMTKView:(MTKView *)view {
    [self _drawInMTKView:view];
}

@end
