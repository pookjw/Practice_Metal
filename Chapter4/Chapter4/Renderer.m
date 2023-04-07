//
//  Renderer.m
//  Chapter4
//
//  Created by Jinwoo Kim on 4/7/23.
//

#import "Renderer.h"
#import "Quad.h"

@interface MTLVertexDescriptor (Category)
@property (class, readonly, nonatomic) MTLVertexDescriptor *defaultLayout;
@end

@implementation MTLVertexDescriptor (Category)

+ (MTLVertexDescriptor *)defaultLayout {
    MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor new];
    
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    vertexDescriptor.layouts[0].stride = __SIZEOF_FLOAT__ * 3;
    
    vertexDescriptor.attributes[1].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[1].offset = 0;
    vertexDescriptor.attributes[1].bufferIndex = 1;
    vertexDescriptor.layouts[1].stride = sizeof(simd_float3);
    
    return vertexDescriptor;
}

@end

@interface Renderer () <MTKViewDelegate>
@property (strong) id<MTLDevice> device;
@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id<MTLLibrary> library;
@property (strong) id<MTLRenderPipelineState> pipelineState;

@property (strong) Quad *quad;
@property (assign) float timer;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView {
    if (self = [self init]) {
        metalView.clearColor = MTLClearColorMake(1.0, 1.0, 0.8, 1.0);
        metalView.delegate = self;
        
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        id<MTLLibrary> library = [device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_main"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
        
        MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
        pipelineDescriptor.vertexFunction = vertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
        pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout;
        
        NSError * _Nullable error = nil;
        id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        NSAssert((error == nil), error.localizedDescription);
        
        Quad *quad = [[Quad alloc] initWithDevice:device scale:0.8f];
        
        metalView.device = device;
        self.device = device;
        self.commandQueue = commandQueue;
        self.library = library;
        self.pipelineState = pipelineState;
        self.quad = quad;
    }
    
    return self;
}

- (void)drawInMTKView:(nonnull MTKView *)view { 
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *descriptor = [view currentRenderPassDescriptor];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    [renderEncoder setRenderPipelineState:self.pipelineState];
    
    //
    
    [renderEncoder setVertexBuffer:self.quad.colorBuffer offset:0 atIndex:1];
    
    //
    
    // buffer는 메모리를 전달
    [renderEncoder setVertexBuffer:self.quad.vertexBuffer offset:0 atIndex:0];
//    [renderEncoder setVertexBuffer:self.quad.indexBuffer offset:0 atIndex:1];
    
    _timer += 0.05;
    float currentTime = sinf(_timer);
    [renderEncoder setVertexBytes:&currentTime length:__SIZEOF_FLOAT__ atIndex:11];
    
//    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
//                      vertexStart:0
//                      vertexCount:self.quad.verticesCount];
//    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
//                      vertexStart:0 
//                      vertexCount:self.quad.indicesCount];
    
    // self.quad.vertexBuffer의 index = 0
    // 이는 attribute를 생성하며 그 정의는 pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout;에서 한다.
    
    // vertices와 colors에 index 주입 
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:self.quad.indicesCount
                               indexType:MTLIndexTypeUInt16
                             indexBuffer:self.quad.indexBuffer
                       indexBufferOffset:0];
    
    //
    
    [renderEncoder endEncoding];
    id<MTLDrawable> drawable = view.currentDrawable;
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size { 
    
}

@end
