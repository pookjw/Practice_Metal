//
//  ViewController.m
//  Chapter2
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
    
    UINavigationItem *navigationItem = self.navigationItem;
    UIBarButtonItem *exportBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(didTriggerExportBarButtonItem:)];
    navigationItem.rightBarButtonItem = exportBarButtonItem;
    [exportBarButtonItem release];
    
    //
    
    MTKView *mtkView = self.mtkView;
    
    mtkView.clearColor = MTLClearColorMake(1., 1., 0.8, 1.);
    
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    assert(device != nil);
    
    mtkView.device = device;
    mtkView.depthStencilPixelFormat = MTLPixelFormatInvalid;
    
    //
    
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    
    NSURL *assetURL = [NSBundle.mainBundle URLForResource:@"train" withExtension:@"usdz"];
    assert(assetURL != nil);
    
    MTLVertexDescriptor *vertexDescriptor = [MTLVertexDescriptor new];
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    vertexDescriptor.layouts[0].stride = sizeof(simd_float3);
    
    MDLVertexDescriptor *meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor);
    [vertexDescriptor release];
    meshDescriptor.attributes[0].name = MDLVertexAttributePosition;
    
    MDLAsset *asset = [[MDLAsset alloc] initWithURL:assetURL vertexDescriptor:meshDescriptor bufferAllocator:allocator];
    
    MDLMesh *mdlMesh = (MDLMesh *)[asset childObjectsOfClass:MDLMesh.class][0];
    [asset release];
    
    [allocator release];
    
    NSError * _Nullable error = nil;
    MTKMesh *mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
    assert(error == nil);
    
    //
    
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
    piplineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor);
    
    //
    
    id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:piplineDescriptor error:&error];
    assert(error == nil);
    [piplineDescriptor release];
    
    id<MTLCommandQueue> commandQueue = [device newCommandQueue];
    id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
    [commandQueue release];
    MTLRenderPassDescriptor *renderPassDescriptor = [mtkView currentRenderPassDescriptor];
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    
    [renderEncoder setRenderPipelineState:pipelineState];
    [pipelineState release];
    
    [renderEncoder setVertexBuffer:mesh.vertexBuffers[0].buffer offset:0 atIndex:0];
    [renderEncoder setTriangleFillMode:MTLTriangleFillModeLines];
    
    for (MTKSubmesh *submesh in mesh.submeshes) {
        [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                                  indexCount:submesh.indexCount
                                   indexType:submesh.indexType
                                 indexBuffer:submesh.indexBuffer.buffer
                           indexBufferOffset:0];
    }
    
    [mesh release];
    
    [renderEncoder endEncoding];;
    [commandBuffer presentDrawable:mtkView.currentDrawable];
    [commandBuffer commit];
    
    //
    
    [device release];
}

- (void)didTriggerExportBarButtonItem:(UIBarButtonItem *)sender {
    assert([MDLAsset canExportFileExtension:@"usda"]);
    
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    assert(device != nil);
    
    //
    
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    MDLMesh *mdlMesh = [[MDLMesh alloc] initConeWithExtent:simd_make_float3(1., 1., 1.)
                                                  segments:simd_make_uint2(10, 10)
                                             inwardNormals:NO
                                                       cap:YES
                                              geometryType:MDLGeometryTypeTriangles
                                                 allocator:allocator];
    
    MDLAsset *asset = [[MDLAsset alloc] initWithBufferAllocator:allocator];
    [allocator release];
    
    [asset addObject:mdlMesh];
    [mdlMesh release];
    
    NSURL *url = [NSURL fileURLWithPath:@"/Users/pookjw/Desktop/test.usda"];
    
    NSError * _Nullable error = nil;
    [asset exportAssetToURL:url error:&error];
    assert(error == nil);
    [asset release];
}

@end
