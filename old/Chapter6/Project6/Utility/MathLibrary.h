//
//  MathLibrary.h
//  Project6
//
//  Created by Jinwoo Kim on 4/11/23.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface MathLibrary : NSObject
+ (float)radiansFromDegrees:(float)degrees;
+ (float)degreesFromRadians:(float)radians;
+ (simd_float4x4)float4x4FromTranslation:(simd_float3)translation;
+ (simd_float4x4)float4x4FromFloat3Scale:(simd_float3)scale;
+ (simd_float4x4)float4x4FromFloatScale:(float)scale;
+ (simd_float4x4)float4x4FromFloatRotationXAngle:(float)angle;
+ (simd_float4x4)float4x4FromFloatRotationYAngle:(float)angle;
+ (simd_float4x4)float4x4FromFloatRotationZAngle:(float)angle;
+ (simd_float4x4)float4x4FromFloat3RotationAngle:(simd_float3)angle;
+ (simd_float4x4)float4x4FromFloat3RotationYXZAngle:(simd_float3)angle;
+ (simd_float3x3)upperLeftFloat3x3FromFloat4x4:(simd_float4x4)float4x4;
+ (simd_float4x4)float4x4FromProjectionFov:(float)fov near:(float)near far:(float)far aspect:(float)aspect lhs:(BOOL)lhs;
+ (simd_float4x4)float4x4FromProjectionFov:(float)fov near:(float)near far:(float)far aspect:(float)aspect;
+ (simd_float4x4)float4x4FromEye:(simd_float3)eye center:(simd_float3)center up:(simd_float3)up;
+ (simd_float4x4)float4x4FromOrthographic:(CGRect)rect near:(float)near far:(float)far;
+ (simd_float4x4)float4x4FromDouble4x4:(simd_double4x4)double4x4;
+ (simd_float3x3)normalFloat3x3FromFloat4x4:(simd_float4x4)float4x4;
+ (simd_float3)xyzFloat3FromFloat4:(simd_float4)float4;
+ (simd_float3)float3FromDouble3:(simd_double3)double3;
@end

NS_ASSUME_NONNULL_END
