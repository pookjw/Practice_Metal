//
//  Renderer.m
//  Chapter8
//
//  Created by Jinwoo Kim on 9/1/24.
//

#import "Renderer.h"
#import "Model.h"
#import "MathLibrary.h"
#import "MTLVertexDescriptor+DefaultLayout.h"

@interface Renderer () <MTKViewDelegate>
@property (retain, readonly, nonatomic) id<MTLDevice> device;
@property (retain, readonly, nonatomic) id<MTLCommandQueue> commandQueue;
@property (retain, readonly, nonatomic) id<MTLRenderPipelineState> pipelineState;
@property (retain, readonly, nonatomic) id<MTLDepthStencilState> depthStencilState;
@property (retain, readonly, nonatomic) Model *house;
@property (retain, readonly, nonatomic) Model *ground;
@property (assign, nonatomic) float timer;
@property (assign, nonatomic) Uniforms uniforms;
@property (assign, nonatomic) Params params;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView {
    if (self = [super init]) {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        
        metalView.device = device;
        metalView.delegate = self;
        metalView.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
        metalView.clearColor = MTLClearColorMake(0.93, 0.97, 1., 1.);
        
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
        pipelineDescriptor.depthAttachmentPixelFormat = metalView.depthStencilPixelFormat;
        pipelineDescriptor.vertexDescriptor = [MTLVertexDescriptor defaultLayout];
        
        NSError * _Nullable error = nil;
        id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        [pipelineDescriptor release];
        assert(error == nil);
        
        //
        
        MTLDepthStencilDescriptor *depthStencilDescriptor = [MTLDepthStencilDescriptor new];
        depthStencilDescriptor.depthCompareFunction = MTLCompareFunctionLess;
        depthStencilDescriptor.depthWriteEnabled = YES;
        
        id<MTLDepthStencilState> depthStencilState = [device newDepthStencilStateWithDescriptor:depthStencilDescriptor];
        [depthStencilDescriptor release];
        
        //
        
        Model *house = [[Model alloc] initWithDevice:device name:@"lowpoly-house.usdz"];
        Model *ground = [[Model alloc] initWithDevice:device name:@"ground" primitive:PrimitivePlane];
        [ground setTextureWithName:@"grass" type:BaseColor device:device];
        ground.tiling = 16;
        
        //
        
        _device = [device retain];
        _commandQueue = [commandQueue retain];
        _pipelineState = [pipelineState retain];
        _depthStencilState = [depthStencilState retain];
        _house = [house retain];
        _ground = [ground retain];
        
        [device release];
        [commandQueue release];
        [pipelineState release];
        [depthStencilState release];
        [house release];
        [ground release];
    }
    
    return self;
}

- (void)dealloc {
    [_device release];
    [_commandQueue release];
    [_pipelineState release];
    [_depthStencilState release];
    [_house release];
    [_ground release];
    [super dealloc];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    float aspect = size.width / size.height;
    
    matrix_float4x4 projectionMatrix = [MathLibrary float4x4FromProjectionFov:[MathLibrary radiansFromDegrees:70.f]
                                                                         near:0.1f
                                                                          far:100.f
                                                                       aspect:aspect
                                                                          lhs:YES];
    
    _uniforms.projectionMatrix = projectionMatrix;
    _params.width = size.width;
    _params.height = size.height;
}

- (void)drawInMTKView:(MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    MTLRenderPassDescriptor *descriptor = view.currentRenderPassDescriptor;
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    [renderEncoder setDepthStencilState:_depthStencilState];
    [renderEncoder setRenderPipelineState:_pipelineState];
    
    //
    
    _timer += 0.005f;
    _uniforms.viewMatrix = simd_inverse([MathLibrary float4x4FromFloat3Translation:simd_make_float3(0.f, 1.f, -4.f)]);
    
    _house.transform->_rotation.y = sin(_timer);
    
    [_house renderInEncoder:renderEncoder uniforms:_uniforms params:_params];
    
    //
    
    _ground.transform->_scale = 40.f;
    _ground.transform->_rotation.z = [MathLibrary radiansFromDegrees:90.f];
    _ground.transform->_rotation.y = sin(_timer);
    
    [_ground renderInEncoder:renderEncoder uniforms:_uniforms params:_params];
    
    //
    
    [renderEncoder endEncoding];
    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

@end
