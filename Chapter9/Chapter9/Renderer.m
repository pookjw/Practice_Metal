//
//  Renderer.m
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import "Renderer.h"
#import "Model.h"
#import "MDLVertexDescriptor+DefaultLayout.h"
#import "MathLibrary.h"

@interface Renderer () <MTKViewDelegate>
@property (retain, nonatomic, readonly) id<MTLDevice> device;
@property (retain, nonatomic, readonly) id<MTLCommandQueue> commandQueue;
@property (retain, nonatomic, readonly) id<MTLRenderPipelineState> pipelineState;
@property (retain, nonatomic, readonly) id<MTLDepthStencilState> depthStencilState;
@property (retain, nonatomic, readonly) Model *house;
@property (retain, nonatomic, readonly) Model *ground;
@property (assign, nonatomic) float timer;
@property (assign, nonatomic) Uniforms uniforms;
@property (assign, nonatomic) Params params;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView {
    if (self = [super init]) {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        id<MTLLibrary> library = [device newDefaultLibrary];
        
        metalView.device = device;
        metalView.delegate = self;
        metalView.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
        metalView.clearColor = MTLClearColorMake(0.93, 0.97, 1., 1.);
        
        //
        
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
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(MDLVertexDescriptor.defaultLayout);
        
        NSError * _Nullable error = nil;
        
        id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        [pipelineDescriptor release];
        assert(error == nil);
        
        MTLDepthStencilDescriptor *depthStencilDescriptor = [MTLDepthStencilDescriptor new];
        depthStencilDescriptor.depthCompareFunction = MTLCompareFunctionLess;
        depthStencilDescriptor.depthWriteEnabled = YES;
        id<MTLDepthStencilState> depthStencilState = [device newDepthStencilStateWithDescriptor:depthStencilDescriptor];
        [depthStencilDescriptor release];
        
        //
        
        Model *house = [[Model alloc] initWithName:@"lowpoly-house.usdz" device:device];
        [house setTextureWithName:@"barn-color" type:BaseColor device:device];
        
        Model *ground = [[Model alloc] initWithName:@"ground" primitive:PrimitivePlane device:device];
        [ground setTextureWithName:@"barn-ground" type:BaseColor device:device];
        ground.tiling = 16;
        
        //
        
        _device = device;
        _commandQueue = commandQueue;
        _pipelineState = pipelineState;
        _depthStencilState = depthStencilState;
        _house = house;
        _ground = ground;
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
    simd_float4x4 projectionMatrix = [MathLibrary float4x4FromProjectionFov:[MathLibrary radiansFromDegrees:70.f]
                                                                       near:0.1f
                                                                        far:100.f
                                                                     aspect:aspect
                                                                        lhs:YES];
    
    _uniforms.projectionMatrix = projectionMatrix;
    _params.width = size.width;
    _params.height = size.height;
}

- (void)drawInMTKView:(MTKView *)view {
    id<MTLDrawable> drawable = view.currentDrawable;
    if (drawable == nil) return;
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    
    _timer += 0.005f;
    _uniforms.viewMatrix = simd_inverse([MathLibrary float4x4FromFloat3Translation:simd_make_float3(0.f, 1.4f, -4.f)]);
    
    [renderEncoder setDepthStencilState:_depthStencilState];
    [renderEncoder setRenderPipelineState:_pipelineState];
    
    // update and render
    self.house.transform->_rotation.y = sin(_timer);
    [self.house renderInEncoder:renderEncoder uniforms:_uniforms params:_params];
    
    self.ground.transform->_scale = 40.f;
    self.ground.transform->_rotation.z = [MathLibrary radiansFromDegrees:90.f];
    self.ground.transform->_rotation.y = sin(_timer);
    [self.ground renderInEncoder:renderEncoder uniforms:_uniforms params:_params];
    
    [renderEncoder endEncoding];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
