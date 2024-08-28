//
//  Renderer.m
//  Chapter7
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import "Renderer.h"
#import "Common.h"
#import "Model.h"
#import "MTLVertexDescriptor+DefaultLayout.h"
#import "MathLibrary.h"
#import "Common.h"

@interface Renderer () <MTKViewDelegate>
@property (retain, nonatomic, readonly) id<MTLDevice> device;
@property (retain, nonatomic, readonly) id<MTLCommandQueue> commandQueue;
@property (retain, nonatomic, readonly) id<MTLRenderPipelineState> modelPipelineState;
@property (retain, nonatomic, readonly) id<MTLRenderPipelineState> quadPipelineState;
@property (retain, nonatomic, readonly) id<MTLDepthStencilState> depthStencilState;
@property (assign, nonatomic) float timer;
@property (assign, nonatomic) Uniforms uniforms;
@property (assign, nonatomic) Params params;
@property (retain, nonatomic, readonly) Model *model;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView options:(Options)options {
    if (self = [super init]) {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        Model *model = [[Model alloc] initWithDevice:device name:@"train.usdz"];
        
        metalView.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
        metalView.delegate = self;
        metalView.device = device;
        metalView.clearColor = MTLClearColorMake(1.f, 1.f, 0.9f, 1.f);
        
        //
        
        id<MTLLibrary> library = [device newDefaultLibrary];
        id<MTLFunction> modelVertexFunction = [library newFunctionWithName:@"vertex_main"];
        id<MTLFunction> quadVertexFunction = [library newFunctionWithName:@"vertex_quad"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
        [library release];
        
        //
        
        MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
        pipelineDescriptor.vertexFunction = quadVertexFunction;
        [quadVertexFunction release];
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        [fragmentFunction release];
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
        
        NSError * _Nullable error = nil;
        id<MTLRenderPipelineState> quadPipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        assert(error == nil);
        
        pipelineDescriptor.vertexFunction = modelVertexFunction;
        [modelVertexFunction release];
        pipelineDescriptor.vertexDescriptor = [MTLVertexDescriptor defaultLayout];
        pipelineDescriptor.depthAttachmentPixelFormat = MTLPixelFormatDepth32Float;
        
        id<MTLRenderPipelineState> modelPipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        assert(error == nil);
        
        MTLDepthStencilDescriptor *depthStencilDescriptor = [MTLDepthStencilDescriptor new];
        depthStencilDescriptor.depthCompareFunction = MTLCompareFunctionLess;
        depthStencilDescriptor.depthWriteEnabled = YES;
        
        id<MTLDepthStencilState> depthStencilState = [device newDepthStencilStateWithDescriptor:depthStencilDescriptor];
        [depthStencilDescriptor release];
        
        //
        
        _device = [device retain];
        _commandQueue = [commandQueue retain];
        _options = options;
        _model = [model retain];
        _quadPipelineState = [quadPipelineState retain];
        _modelPipelineState = [modelPipelineState retain];
        _depthStencilState = [depthStencilState retain];
        
        //
        
        [device release];
        [commandQueue release];
        [model release];
        [quadPipelineState release];
        [modelPipelineState release];
        [depthStencilState release];
    }
    
    return self;
}

- (void)dealloc {
    [_device release];
    [_commandQueue release];
    [_modelPipelineState release];
    [_quadPipelineState release];
    [_depthStencilState release];
    [_model release];
    [super dealloc];
}

- (void)_drawInMTKView:(MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *descriptor = [view currentRenderPassDescriptor];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    [renderEncoder setFragmentBytes:&_params length:sizeof(Params) atIndex:ParamsBuffer];
    
    if (self.options == OptionsTrain) {
        [self renderModelInEncoder:renderEncoder];
    } else {
        [self renderQuadInEncoder:renderEncoder];
    }
    
    [renderEncoder endEncoding];
    
    [commandBuffer presentDrawable:[view currentDrawable]];
    [commandBuffer commit];
}

- (void)renderModelInEncoder:(id<MTLRenderCommandEncoder>)encoder {
    [encoder setRenderPipelineState:self.modelPipelineState];
    [encoder setDepthStencilState:self.depthStencilState];
    
    _timer += 0.005f;
    _uniforms.viewMatrix = simd_inverse([MathLibrary float4x4FromFloat3Translation:simd_make_float3(0.f, 0.f, -2.f)]);
    _model.transform->_position.y = -0.6f;
    _model.transform->_rotation.y = sin(_timer);
    _uniforms.modelMatrix = _model.transform.modelMatrix;
    
    [encoder setVertexBytes:&_uniforms length:sizeof(Uniforms) atIndex:UniformBuffer];
    [_model renderInEncoder:encoder];
}

- (void)renderQuadInEncoder:(id<MTLRenderCommandEncoder>)encoder {
    [encoder setRenderPipelineState:self.quadPipelineState];
    [encoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    float aspect = size.width / size.height;
    simd_float4x4 projectionMatrix = [MathLibrary float4x4FromProjectionFov:[MathLibrary radiansFromDegrees:70.f] near:0.1f far:100.f aspect:aspect lhs:YES];
    _uniforms.projectionMatrix = projectionMatrix;
    
    _params.width = size.width;
    _params.height = size.height;
}

- (void)drawInMTKView:(MTKView *)view {
    [self _drawInMTKView:view];
}

@end
