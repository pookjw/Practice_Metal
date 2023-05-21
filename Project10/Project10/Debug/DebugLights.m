//
//  DebugLights.m
//  Project10
//
//  Created by Jinwoo Kim on 5/17/23.
//

#import "DebugLights.h"

@implementation DebugLights

+ (id<MTLRenderPipelineState>)linePipelineStateWithDevice:(id<MTLDevice>)device library:(id<MTLLibrary>)library {
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_debug"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_debug_line"];
    
    MTLRenderPipelineDescriptor *descriptor = [MTLRenderPipelineDescriptor new];
    descriptor.vertexFunction = vertexFunction;
    descriptor.fragmentFunction = fragmentFunction;
    descriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    descriptor.depthAttachmentPixelFormat = MTLPixelFormatDepth32Float;
    
    NSError * _Nullable error = nil;
    id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:descriptor error:&error];
    NSAssert(!error, error.localizedDescription);
    
    return pipelineState;
}

+ (id<MTLRenderPipelineState>)pointPipelineStateWithDevice:(id<MTLDevice>)device library:(id<MTLLibrary>)library {
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_debug"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_debug_point"];
    
    MTLRenderPipelineDescriptor *descriptor = [MTLRenderPipelineDescriptor new];
    descriptor.vertexFunction = vertexFunction;
    descriptor.fragmentFunction = fragmentFunction;
    descriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    descriptor.depthAttachmentPixelFormat = MTLPixelFormatDepth32Float;
    
    NSError * _Nullable error = nil;
    id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:descriptor error:&error];
    NSAssert(!error, error.localizedDescription);
    
    return pipelineState;
}

+ (void)drawLights:(Light *)lights lightCount:(NSUInteger)lightCount encoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)uniforms device:(id<MTLDevice>)device library:(id<MTLLibrary>)library {
    encoder.label = @"Debug lights";
    
    for (NSUInteger i = 0; i < lightCount; i++) {
        Light light = lights[i];
        
        switch (light.type) {
            case _Point:
                [self debugDrawPointWithEncoder:encoder uniforms:uniforms position:light.position color:light.color device:device library:library];
                break;
            case Spot:
                [self debugDrawPointWithEncoder:encoder uniforms:uniforms position:light.position color:simd_make_float3(0.f, 0.f, 1.f) device:device library:library];
                [self debugDrawLineWithEncoder:encoder uniforms:uniforms position:light.position direction:light.coneDirection color:light.color device:device library:library];
                break;
            case Sun:
                [self debugDrawDirectionWithEncoder:encoder uniforms:uniforms direction:light.position color:simd_make_float3(1.f, 0.f, 0.f) count:5 device:device library:library];
                break;
            default:
                break;
        }
    }
}

+ (void)debugDrawPointWithEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)uniforms position:(simd_float3)position color:(simd_float3)color device:(id<MTLDevice>)device library:(id<MTLLibrary>)library {
    simd_float3 vertices[1] = {position};
    [encoder setVertexBytes:&vertices length:sizeof(vertices) atIndex:0];
    
    uniforms.modelMatrix = matrix_identity_float4x4;
    
    [encoder setVertexBytes:&uniforms length:sizeof(Uniforms) atIndex:UniformsBuffer];
    [encoder setFragmentBytes:&color length:sizeof(simd_float3) atIndex:1];
    
    [encoder setRenderPipelineState:[self pointPipelineStateWithDevice:device library:library]];
    
    [encoder drawPrimitives:MTLPrimitiveTypePoint vertexStart:0 vertexCount:(sizeof(vertices) / sizeof(simd_float3))];
}

+ (void)debugDrawDirectionWithEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)uniforms direction:(simd_float3)direction color:(simd_float3)color count:(NSUInteger)count device:(id<MTLDevice>)device library:(id<MTLLibrary>)library {
    NSUInteger size = 4 * count * sizeof(simd_float3);
    simd_float3 *vertices = malloc(size);
    
    for (NSInteger i = -count; i < (NSInteger)count; i++) {
        float value = i * 0.4f;
        vertices[2 * (i + count)] = simd_make_float3(value, 0.f, value);
        vertices[2 * (i + count) + 1] = simd_make_float3(direction.x + value, direction.y, direction.z + value);
    }
    
    id<MTLBuffer> buffer = [device newBufferWithBytes:vertices length:size options:0];
    free(vertices);
    
    uniforms.modelMatrix = matrix_identity_float4x4;
    
    [encoder setVertexBytes:&uniforms length:sizeof(Uniforms) atIndex:UniformsBuffer];
    [encoder setFragmentBytes:&color length:sizeof(simd_float3) atIndex:1];
    [encoder setVertexBuffer:buffer offset:0 atIndex:0];
    
    [encoder setRenderPipelineState:[self linePipelineStateWithDevice:device library:library]];
    [encoder drawPrimitives:MTLPrimitiveTypeLine vertexStart:0 vertexCount:size];
}

+ (void)debugDrawLineWithEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)uniforms position:(simd_float3)position direction:(simd_float3)direction color:(simd_float3)color device:(id<MTLDevice>)device library:(id<MTLLibrary>)library {
    simd_float3 vertices[2] = {
        position,
        simd_make_float3(position.x + direction.x, position.y + direction.y, position.z + direction.z)
    };
    
    id<MTLBuffer> buffer = [device newBufferWithBytes:&vertices length:sizeof(vertices) options:0];
    
    uniforms.modelMatrix = matrix_identity_float4x4;
    
    [encoder setVertexBytes:&uniforms length:sizeof(Uniforms) atIndex:UniformsBuffer];
    [encoder setFragmentBytes:&color length:sizeof(simd_float3) atIndex:1];
    [encoder setVertexBuffer:buffer offset:0 atIndex:0];
    
    // render line
    [encoder setRenderPipelineState:[self linePipelineStateWithDevice:device library:library]];
    [encoder drawPrimitives:MTLPrimitiveTypeLine vertexStart:0 vertexCount:sizeof(vertices) / sizeof(simd_float3)];
    
    // render starting point
//    [encoder setRenderPipelineState:[self pointPipelineStateWithDevice:device library:library]];
//    [encoder drawPrimitives:MTLPrimitiveTypePoint vertexStart:0 vertexCount:1];
}

@end
