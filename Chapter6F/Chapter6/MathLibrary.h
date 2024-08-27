//
//  MathLibrary.h
//  Chapter6
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#include <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface MathLibrary : NSObject
+ (float)degreesFromRadians:(float)radians;
+ (float)radiansFromDegrees:(float)degrees;

+ (simd_float4x4)float4x4FromFloat3Translation:(simd_float3)translation;
+ (simd_float4x4)float4x4FromFloat3Scale:(simd_float3)scale;
+ (simd_float4x4)float4x4FromScale:(float)scale;

+ (simd_float4x4)float4x4FromRotationXAngle:(float)angle;
+ (simd_float4x4)float4x4FromRotationYAngle:(float)angle;
+ (simd_float4x4)float4x4FromRotationZAngle:(float)angle;
+ (simd_float4x4)float4x4FromRotationXYZAngle:(float)angle;
+ (simd_float4x4)float4x4FromRotationYXZAngle:(float)angle;

+ (simd_float3x3)upperLeftFloat3x3FromFloat4x4:(simd_float4x4)matrix;

+ (simd_float4x4)float4x4FromProjectionFov:(float)fov near:(float)near far:(float)far aspect:(float)aspect lhs:(BOOL)lhs;
+ (simd_float4x4)float4x4FromEye:(float)eye center:(simd_float3)center up:(simd_float3)up;
+ (simd_float4x4)float4x4FromOrthographicRect:(CGRect)rect near:(float)near far:(float)far;
+ (simd_float4x4)float4x4FromDouble4x4:(simd_double4x4)matrix;
+ (simd_float4)float4FromDouble4:(simd_double4)matrix;

+ (simd_float3x3)float3x3FromNormalFloat4x4:(simd_float4x4)matrix;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
