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
        
        //
        
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
        
//        MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor new];
//        vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
//        vertexDescriptor.attributes[0].offset = 0;
//        vertexDescriptor.attributes[0].bufferIndex = 0;
//        vertexDescriptor.layouts[0].stride = sizeof(simd_float3);
//        
//        MDLVertexDescriptor *meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor);
        
        MDLVertexDescriptor *meshDescriptor = [MDLVertexDescriptor new];
        meshDescriptor.attributes[0].format = MDLVertexFormatFloat3;
        meshDescriptor.attributes[0].offset = 0;
        meshDescriptor.attributes[0].bufferIndex = 0;
        meshDescriptor.layouts[0].stride = sizeof(simd_float3);
        meshDescriptor.attributes[0].name = MDLVertexAttributePosition;
        
        
        NSURL *assetURL = [NSBundle.mainBundle URLForResource:@"train" withExtension:@"usdz"];
        assert(assetURL != nil);
        MDLAsset *asset = [[MDLAsset alloc] initWithURL:assetURL vertexDescriptor:meshDescriptor bufferAllocator:allocator];
        [meshDescriptor release];
        
        MDLMesh *mdlMesh = (MDLMesh *)[asset childObjectsOfClass:MDLMesh.class][0];
        [asset release];
        
        NSError * _Nullable error = nil;
        MTKMesh *mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
        assert(error == nil);
        
        //
        
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
