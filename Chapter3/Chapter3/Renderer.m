//
//  Renderer.m
//  Chapter3
//
//  Created by Jinwoo Kim on 8/26/24.
//

#import "Renderer.h"

@interface Renderer () <MTKViewDelegate>
@property (retain, nonatomic, nullable) id<MTLDevice> device;
@property (retain, nonatomic, nullable) id<MTLCommandQueue> commandQueue;
@property (retain, nonatomic, nullable) id<MTLLibrary> library;
@property (retain, nonatomic, nullable) MTKMesh *mesh;
@property (retain, nonatomic, nullable) id<MTLBuffer> vertexBuffer;
@property (retain, nonatomic, nullable) id<MTLRenderPipelineState> piplineState;
@end

@implementation Renderer

- (instancetype)initWithMetalView:(MTKView *)metalView {
    if (self = [super init]) {
        metalView.delegate = self;
        metalView.clearColor = MTLClearColorMake(1., 1., 0.8, 1.);
        metalView.depthStencilPixelFormat = MTLPixelFormatInvalid;
        
        //
        
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        id<MTLCommandQueue> commandQueue = [device newCommandQueue];
        
        metalView.device = device;
        
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
        MDLMesh *mdlMesh = [[MDLMesh alloc] initBoxWithExtent:simd_make_float3(0.8, 0.8, 0.8)
                                                     segments:simd_make_uint3(1, 1, 1)
                                                inwardNormals:NO
                                                 geometryType:MDLGeometryTypeTriangles
                                                    allocator:allocator];
        [allocator release];
        
        NSError * _Nullable error = nil;
        MTKMesh *mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
        assert(error == nil);
        
        id<MTLLibrary> library = [device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_main"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
        
        MTLRenderPipelineDescriptor *piplineDescriptor = [MTLRenderPipelineDescriptor new];
        piplineDescriptor.vertexFunction = vertexFunction;
        [vertexFunction release];
        piplineDescriptor.fragmentFunction = fragmentFunction;
        [fragmentFunction release];
        piplineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat;
        piplineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor);
        [mdlMesh release];
        
        id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:piplineDescriptor error:&error];
        [piplineDescriptor release];
        assert(error == nil);
        
        id<MTLBuffer> vertexBuffer = mesh.vertexBuffers[0].buffer;
        
        //
        
        self.device = device;
        self.commandQueue = commandQueue;
        self.mesh = mesh;
        self.vertexBuffer = vertexBuffer;
        self.piplineState = pipelineState;
        
        [device release];
        [commandQueue release];
        [mesh release];
        [pipelineState release];
    }
    
    return self;
}

- (void)dealloc {
    [_device release];
    [_commandQueue release];
    [_library release];
    [_mesh release];
    [_vertexBuffer release];
    [_piplineState release];
    [super dealloc];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

- (void)drawInMTKView:(MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *descriptor = [view currentRenderPassDescriptor];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    //
    
    [renderEncoder setRenderPipelineState:self.piplineState];
    [renderEncoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
    
    for (MTKSubmesh *submesh in self.mesh.submeshes) {
        [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                                  indexCount:submesh.indexCount
                                   indexType:submesh.indexType
                                 indexBuffer:submesh.indexBuffer.buffer
                           indexBufferOffset:submesh.indexBuffer.offset];
    }
    
    //
    
    [renderEncoder endEncoding];
    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

@end
