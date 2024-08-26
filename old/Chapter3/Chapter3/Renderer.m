//
//  Renderer.m
//  Chapter3
//
//  Created by Jinwoo Kim on 4/6/23.
//

#import "Renderer.h"

@interface Renderer () <MTKViewDelegate>
@property (strong) id<MTLDevice> device;
@property (strong) id<MTLCommandQueue> commandQueue;
@property (strong) id<MTLLibrary> library;
@property (strong) MTKMesh *mesh;
@property (strong) id<MTLBuffer> vertexBuffer;
@property (strong) id<MTLRenderPipelineState> pipelineState;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView {
    if (self = [self init]) {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        
        id<MTLLibrary> library = [device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_main"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
        
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
        MDLMesh *mdlMesh = [[MDLMesh alloc] initBoxWithExtent:vector3(0.8f, 0.8f, 0.8f)
                                                     segments:simd_make_uint3(1, 1, 1)
                                                inwardNormals:NO
                                                 geometryType:MDLGeometryTypeTriangles
                                                    allocator:allocator];
        
        NSError * _Nullable error = nil;
        MTKMesh *mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
        NSAssert((error == nil), error.localizedDescription);
        
        id<MTLBuffer> vertexBuffer = mesh.vertexBuffers[0].buffer;
        
        MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
        pipelineDescriptor.vertexFunction = vertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIOWithError(mdlMesh.vertexDescriptor, &error);
        NSAssert((error == nil), error.localizedDescription);
        
        id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        NSAssert((error == nil), error.localizedDescription);
        
        metalView.delegate = self;
        metalView.clearColor = MTLClearColorMake(1.0, 1.0, 0.8, 1.0);
        metalView.device = device;
        
        self.device = device;
        self.commandQueue = commandQueue;
        self.library = library;
        self.mesh = mesh;
        self.vertexBuffer = vertexBuffer;
        self.pipelineState = pipelineState;
    }
    
    return self;
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

- (void)drawInMTKView:(MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *descriptor = [view currentRenderPassDescriptor];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    //
    
    [renderEncoder setRenderPipelineState:self.pipelineState];
    
    [renderEncoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
    [self.mesh.submeshes enumerateObjectsUsingBlock:^(MTKSubmesh * _Nonnull submesh, NSUInteger idx, BOOL * _Nonnull stop) {
        [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                                  indexCount:submesh.indexCount
                                   indexType:submesh.indexType
                                 indexBuffer:submesh.indexBuffer.buffer
                           indexBufferOffset:submesh.indexBuffer.offset];
    }];
    
    //
    
    [renderEncoder endEncoding];
    id<CAMetalDrawable> drawable = [view currentDrawable];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
