//
//  ViewController.m
//  Chapter1
//
//  Created by Jinwoo Kim on 8/26/24.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>

@interface ViewController ()
@property (retain, nonatomic) IBOutlet MTKView *mtkView;
@end

@implementation ViewController

- (void)dealloc {
    [_mtkView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    assert(device != nil);
    
    self.mtkView.device = device;
    self.mtkView.clearColor = MTLClearColorMake(1., 1., 0.8, 1.);
    self.mtkView.depthStencilPixelFormat = MTLPixelFormatInvalid;
    
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    MDLMesh *mdlMesh = [[MDLMesh alloc] initSphereWithExtent:simd_make_float3(0.75, 0.75, 0.75)
                                                    segments:simd_make_uint2(100, 100)
                                               inwardNormals:NO
                                                geometryType:MDLGeometryTypeTriangles
                                                   allocator:allocator];
    [allocator release];
    
    NSError * _Nullable error = nil;
    MTKMesh *mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
    [mdlMesh release];
    assert(error == nil);
    
    id<MTLLibrary> library = [device newLibraryWithURL:[NSBundle.mainBundle URLForResource:@"default" withExtension:@"metallib"] error:&error];
    assert(error == nil);
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_main"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];
    [library release];
    
    MTLRenderPipelineDescriptor *piplineDescriptor = [MTLRenderPipelineDescriptor new];
    piplineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    piplineDescriptor.vertexFunction = vertexFunction;
    [vertexFunction release];
    piplineDescriptor.fragmentFunction = fragmentFunction;
    [fragmentFunction release];
    piplineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIOWithError(mesh.vertexDescriptor, &error);
    assert(error == nil);
    
    id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:piplineDescriptor error:&error];
    assert(error == nil);
    [piplineDescriptor release];
    
    //
    
    id<MTLCommandQueue> commandQueue = [device newCommandQueue];
    id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
    
    MTLRenderPassDescriptor *renderPassDescriptor = [self.mtkView currentRenderPassDescriptor];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    [renderEncoder setRenderPipelineState:pipelineState];
    [pipelineState release];
    
    [renderEncoder setVertexBuffer:mesh.vertexBuffers[0].buffer offset:0 atIndex:0];
    
    [device release];
    
    //
    
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:mesh.submeshes[0].indexCount
                               indexType:mesh.submeshes[0].indexType
                             indexBuffer:mesh.submeshes[0].indexBuffer.buffer
                       indexBufferOffset:0];
    [mesh release];
    
    [renderEncoder endEncoding];
    
    //
    
    [commandBuffer presentDrawable:self.mtkView.currentDrawable];
    [commandBuffer commit];
}

@end
