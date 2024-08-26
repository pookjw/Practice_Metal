//
//  ViewController.m
//  Chapter1
//
//  Created by Jinwoo Kim on 4/6/23.
//

#import "ViewController.h"
#import <MetalKit/MetalKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<MTLDevice> _Nullable device = MTLCreateSystemDefaultDevice();
    assert(device);
    
    CGRect frame = CGRectMake(0.f, 0.f, 600.f, 600.f);
    MTKView *mtkView = [[MTKView alloc] initWithFrame:frame device:device];
    mtkView.clearColor = MTLClearColorMake(1.0, 1.0, 0.8, 1.0);
    
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    
    MDLMesh *mdlMesh = [[MDLMesh alloc] initSphereWithExtent:vector3(0.2f, 0.75f, 0.2f)
                                              segments:simd_make_uint2(100, 100)
                                         inwardNormals:NO
                                          geometryType:MDLGeometryTypeTriangles
                                             allocator:allocator];
    //    MDLMesh *mdlMesh = [[MDLMesh alloc] initConeWithExtent:vector3(1.f, 1.f, 1.f)
    //                                                  segments:simd_make_uint2(10, 10)
    //                                             inwardNormals:NO
    //                                                       cap:YES
    //                                              geometryType:MDLGeometryTypeTriangles 
    //                                                 allocator:allocator];
    
    NSError * _Nullable error = nil;
    MTKMesh *mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
    NSAssert((error == nil), error.localizedDescription);
    
    
    id<MTLCommandQueue> _Nullable queue = [device newCommandQueue];
    assert(queue);
    
    NSURL * _Nullable url = [NSBundle.mainBundle URLForResource:@"default" withExtension:@"metallib"];
    assert(url);
    id<MTLLibrary> library = [device newLibraryWithURL:url error:&error];
    NSAssert((error == nil), error.localizedDescription);
    
    id<MTLFunction> _Nullable vertexFunction = [library newFunctionWithName:@"vertex_main"];
    assert(vertexFunction);
    id<MTLFunction> _Nullable fragmentFunction = [library newFunctionWithName:@"fragment_main"];
    assert(fragmentFunction);
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
    pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor);
    
    id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
    NSAssert((error == nil), error.localizedDescription);
    
    id<MTLCommandBuffer> _Nullable commandBuffer = [queue commandBuffer];
    assert(commandBuffer);
    MTLRenderPassDescriptor * _Nullable renderPassDescriptor = [mtkView currentRenderPassDescriptor];
    assert(renderPassDescriptor);
    id<MTLRenderCommandEncoder> _Nullable renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    assert(renderEncoder);
    
    [renderEncoder setRenderPipelineState:pipelineState];
    [renderEncoder setVertexBuffer:mesh.vertexBuffers[0].buffer offset:0 atIndex:0];
    
    [renderEncoder setTriangleFillMode:MTLTriangleFillModeLines];
    MTKSubmesh *submesh = mesh.submeshes.firstObject;
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle 
                              indexCount:submesh.indexCount 
                               indexType:submesh.indexType
                             indexBuffer:submesh.indexBuffer.buffer
                       indexBufferOffset:0];
    
    [renderEncoder endEncoding];
    [commandBuffer presentDrawable:mtkView.currentDrawable];
    [commandBuffer commit];
    
    [self.view addSubview:mtkView];
}

@end
