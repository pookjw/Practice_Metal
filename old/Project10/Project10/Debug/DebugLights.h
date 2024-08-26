//
//  DebugLights.h
//  Project10
//
//  Created by Jinwoo Kim on 5/17/23.
//

#import <MetalKit/MetalKit.h>
#import "common.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebugLights : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (id<MTLRenderPipelineState>)linePipelineStateWithDevice:(id<MTLDevice>)device library:(id<MTLLibrary>)library;
+ (id<MTLRenderPipelineState>)pointPipelineStateWithDevice:(id<MTLDevice>)device library:(id<MTLLibrary>)library;
+ (void)drawLights:(Light *)lights lightCount:(NSUInteger)lightCount encoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)uniforms device:(id<MTLDevice>)device library:(id<MTLLibrary>)library;
+ (void)debugDrawPointWithEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)uniforms position:(simd_float3)position color:(simd_float3)color device:(id<MTLDevice>)device library:(id<MTLLibrary>)library;
+ (void)debugDrawDirectionWithEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)uniforms direction:(simd_float3)direction color:(simd_float3)color count:(NSUInteger)count device:(id<MTLDevice>)device library:(id<MTLLibrary>)library;
+ (void)debugDrawLineWithEncoder:(id<MTLRenderCommandEncoder>)encoder uniforms:(Uniforms)uniforms position:(simd_float3)position direction:(simd_float3)direction color:(simd_float3)color device:(id<MTLDevice>)device library:(id<MTLLibrary>)library;
@end

NS_ASSUME_NONNULL_END
