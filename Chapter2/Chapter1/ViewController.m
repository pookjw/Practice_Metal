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
//    MDLMesh *mdlMesh = [[MDLMesh alloc] initSphereWithExtent:vector3(0.75f, 0.75f, 0.75f)
//                                              segments:simd_make_uint2(100, 100)
//                                         inwardNormals:NO
//                                          geometryType:MDLGeometryTypeTriangles
//                                             allocator:allocator];
//    MDLMesh *mdlMesh = [[MDLMesh alloc] initConeWithExtent:vector3(1.f, 1.f, 1.f)
//                                                  segments:simd_make_uint2(10, 10)
//                                             inwardNormals:NO
//                                                       cap:YES
//                                              geometryType:MDLGeometryTypeTriangles 
//                                                 allocator:allocator];
    
//#pragma mark - Export MDLMesh as .obj File
//    MDLAsset *asset = [MDLAsset new];
//    [asset addObject:mdlMesh];
//    BOOL canExport = [MDLAsset canExportFileExtension:@"obj"];
//    NSAssert(canExport, @"ERROR");
//    NSError * _Nullable exportError = nil;
//    [asset exportAssetToURL:[NSURL fileURLWithPath:@"/Users/pookjw/Desktop/test.obj" isDirectory:YES] error:&exportError];
//    NSAssert((exportError == nil), exportError.localizedDescription);
    
    NSURL * _Nullable trainAssetURL = [NSBundle.mainBundle URLForResource:@"train" withExtension:@"obj"];
    assert(trainAssetURL);
    
    MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor new];
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    vertexDescriptor.layouts[0].stride = sizeof(simd_float3);
    
    MDLVertexDescriptor *meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor);
    ((MDLVertexAttribute *)meshDescriptor.attributes[0]).name = MDLVertexAttributePosition;
    
    MDLAsset *asset = [[MDLAsset alloc] initWithURL:trainAssetURL
                                   vertexDescriptor:meshDescriptor 
                                    bufferAllocator:allocator];
    MDLMesh *mdlMesh = (MDLMesh *)[[asset childObjectsOfClass:MDLMesh.class] firstObject];
    
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
    
    [mesh.submeshes enumerateObjectsUsingBlock:^(MTKSubmesh * _Nonnull submesh, NSUInteger idx, BOOL * _Nonnull stop) {
        [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                                  indexCount:submesh.indexCount
                                   indexType:submesh.indexType
                                 indexBuffer:submesh.indexBuffer.buffer
                           indexBufferOffset:submesh.indexBuffer.offset];
    }];
    
    [renderEncoder endEncoding];
    [commandBuffer presentDrawable:mtkView.currentDrawable];
    [commandBuffer commit];
    
    [self.view addSubview:mtkView];
}

@end
