//
//  Renderer.m
//  Chapter7
//
//  Created by Jinwoo Kim on 4/14/23.
//

#import "Renderer.h"
#import "MDLVertexDescriptor+Category.h"
#import "Model.h"
#import "Common.h"
#import "MathLibrary.h"

@interface Renderer () <MTKViewDelegate>
@property (strong) id<MTLDevice> device;
@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id<MTLLibrary> library;
@property (strong) id<MTLRenderPipelineState> modelPipelineState;
@property (strong) id<MTLRenderPipelineState> quadPipelineState;

@property (strong) Model *model;
@property float timer;
@property Uniforms uniforms;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView options:(Options)options {
    if (self = [self init]) {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        id<MTLLibrary> library = [device newDefaultLibrary];
        id<MTLFunction> modelVertexFunction = [library newFunctionWithName:@"vertex_main"];
        id<MTLFunction> quadVertexFunction = [library newFunctionWithName:@"vertex_quad"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
        
        MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
        pipelineDescriptor.vertexFunction = quadVertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
        
        NSError * _Nullable error = nil;
        id<MTLRenderPipelineState> quadPipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        NSAssert((error == nil), error.localizedDescription);
        
        pipelineDescriptor.vertexFunction = modelVertexFunction;
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(MDLVertexDescriptor.defaultLayout);
        id<MTLRenderPipelineState> modelPipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        NSAssert((error == nil), error.localizedDescription);
        
        metalView.clearColor = MTLClearColorMake(1.0f, 1.0f, 0.9f, 1.0f);
        metalView.delegate = self;
        metalView.device = device;
        
        Model *model = [[Model alloc] initWithDevice:device name:@"train.usd"];
        
        self.device = device;
        self.commandQueue = commandQueue;
        self.library = library;
        self.quadPipelineState = quadPipelineState;
        self.modelPipelineState = modelPipelineState;
        self.model = model;
    }
    
    return self;
}

- (void)renderModelWithEncoder:(id<MTLRenderCommandEncoder>)encoder {
    [encoder setRenderPipelineState:self.modelPipelineState];
    
    self.timer += 0.005f;
    self->_uniforms.viewMatrix = simd_inverse([MathLibrary float4x4FromTranslation:simd_make_float3(0.f, 0.f, -2.f)]);
    self.model.transform->_position.y = -0.6f;
    self.model.transform->_rotation.y = sinf(self.timer);
    self->_uniforms.modelMatrix = self.model.transform.modelMatrix;
    
    [encoder setVertexBytes:&(self->_uniforms)
                     length:sizeof(Uniforms)
                    atIndex:11];
    
    [self.model renderWithEncoder:encoder];
}

- (void)renderQuadWithEncoder:(id<MTLRenderCommandEncoder>)encoder {
    [encoder setRenderPipelineState:self.quadPipelineState];
    [encoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size { 
    CGFloat aspect = view.bounds.size.width / view.bounds.size.height;
    simd_float4x4 projectionMatrix = [MathLibrary float4x4FromProjectionFov:[MathLibrary radiansFromDegrees:70.f]
                                                                       near:0.1f
                                                                        far:100.f
                                                                     aspect:aspect];
    
    self->_uniforms.projectionMatrix = projectionMatrix;
}

- (void)drawInMTKView:(nonnull MTKView *)view { 
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *descriptor = view.currentRenderPassDescriptor;
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    switch (self.options) {
        case OptionsTrain:
            [self renderModelWithEncoder:renderEncoder];
            break;
        case OptionsQuad:
            [self renderQuadWithEncoder:renderEncoder];
            break;
        default:
            break;
    }
    
    [renderEncoder endEncoding];
    id<CAMetalDrawable> drawable = view.currentDrawable;
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
