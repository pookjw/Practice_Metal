//
//  Renderer.m
//  Project6
//
//  Created by Jinwoo Kim on 4/13/23.
//

#import "Renderer.h"
#import "Model.h"
#import "MDLVertexDescriptor+Category.h"
#import "Common.h"
#import "MathLibrary.h"

@interface Renderer () <MTKViewDelegate>
@property (strong) id<MTLDevice> device;
@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id<MTLLibrary> library;
@property (strong) id<MTLRenderPipelineState> pipelineState;

@property (strong) Model *model;
@property float timer;
@property Uniforms uniforms;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView {
    if (self = [self init]) {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        id<MTLLibrary> library = [device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_main"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
        
        MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
        pipelineDescriptor.vertexFunction = vertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(MDLVertexDescriptor.defaultLayout);
        
        NSError * _Nullable error = nil;
        id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        NSAssert((error == nil), error.localizedDescription);
        
        Model *model = [[Model alloc] initWithDevice:device name:@"train.usd"];
        
        metalView.device = device;
        metalView.clearColor = MTLClearColorMake(1.0f, 1.0f, 0.9f, 1.0f);
        metalView.delegate = self;
        
//        simd_float4x4 translation = [MathLibrary float4x4FromTranslation:simd_make_float3(0.5f, -0.4f, 0.f)];
//        simd_float4x4 rotation = [MathLibrary float4x4FromFloat3RotationAngle:simd_make_float3(0.f, 0.f, [MathLibrary radiansFromDegrees:45.f])];
//        Uniforms uniforms = {
//            .modelMatrix = matrix_multiply(translation, rotation),
//            .viewMatrix = simd_inverse([MathLibrary float4x4FromTranslation:simd_make_float3(0.8f, 0.f, 0.f)])
//        };
        
        self.device = device;
        self.commandQueue = commandQueue;
        self.library = library;
        self.pipelineState = pipelineState;
        self.model = model;
//        self.uniforms = uniforms;
        
        [self mtkView:metalView drawableSizeWillChange:metalView.bounds.size];
    }
    
    return self;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size { 
    CGFloat aspect = view.bounds.size.width / view.bounds.size.height;
    simd_float4x4 projectionMatrix = [MathLibrary float4x4FromProjectionFov:[MathLibrary radiansFromDegrees:45.f]
                                                                       near:0.1f
                                                                        far:100.f
                                                                     aspect:aspect];
    
    Uniforms uniforms = {
        .modelMatrix = self.uniforms.modelMatrix,
        .viewMatrix = self.uniforms.viewMatrix,
        .projectionMatrix = projectionMatrix
    };
    
    self.uniforms = uniforms;
}

- (void)drawInMTKView:(nonnull MTKView *)view { 
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *descriptor = [view currentRenderPassDescriptor];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    [renderEncoder setRenderPipelineState:self.pipelineState];
    [renderEncoder setTriangleFillMode:MTLTriangleFillModeLines];
    
    self.timer += 0.005f;
    
    simd_float4x4 translationMatrix = [MathLibrary float4x4FromTranslation:simd_make_float3(0.f, -0.6f, 0.f)];
    simd_float4x4 rotationMatrix = [MathLibrary float4x4FromFloatRotationYAngle:sinf(self.timer)];
    
//    Uniforms uniforms = {
//        .modelMatrix = simd_inverse([MathLibrary float4x4FromTranslation:simd_make_float3(0.f, 0.f, -3.f)]),
//        .viewMatrix = matrix_multiply(translationMatrix, rotationMatrix),
//        .projectionMatrix = self.uniforms.projectionMatrix
//    };
//    self.uniforms = uniforms;
    self.model.transform.position = simd_make_float3(self.model.transform.position.x, -0.6f, self.model.transform.position.z);
    self.model.transform.rotation = simd_make_float3(self.model.transform.rotation.x, sinf(self.timer), self.model.transform.rotation.z);
    
    Uniforms uniforms = {
        .modelMatrix = self.model.transform.modelMatrix,
        .viewMatrix = simd_inverse([MathLibrary float4x4FromTranslation:simd_make_float3(0.f, 0.f, -3.f)]),
        .projectionMatrix = self.uniforms.projectionMatrix
    };
    self.uniforms = uniforms;
    
    [renderEncoder setVertexBytes:&(self->_uniforms) length:sizeof(Uniforms) atIndex:11];
    
    [self.model renderWithEncoder:renderEncoder];
    
    [renderEncoder endEncoding];
    id<CAMetalDrawable> drawable = view.currentDrawable;
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
