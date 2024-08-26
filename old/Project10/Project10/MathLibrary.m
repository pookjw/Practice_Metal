//
//  MathLibrary.m
//  Project6
//
//  Created by Jinwoo Kim on 4/11/23.
//

#import "MathLibrary.h"

@implementation MathLibrary

+ (float)radiansFromDegrees:(float)degrees {
    return degrees * M_PI / 180.f;
}

+ (float)degreesFromRadians:(float)radians {
    return 180.f * radians / M_PI;
}

+ (simd_float4x4)float4x4FromTranslation:(simd_float3)translation {
    simd_float4x4 result = matrix_identity_float4x4;
    result.columns[3].x = translation.x;
    result.columns[3].y = translation.y;
    result.columns[3].z = translation.z;
    
    return result;
}

+ (simd_float4x4)float4x4FromFloat3Scale:(simd_float3)scale {
    simd_float4x4 result = matrix_identity_float4x4;
    result.columns[0].x = scale.x;
    result.columns[1].y = scale.y;
    result.columns[2].z = scale.z;
    
    return result;
}

+ (simd_float4x4)float4x4FromFloatScale:(float)scale {
    simd_float4x4 result = matrix_identity_float4x4;
    result.columns[3].w = 1.f / scale;
    return result;
}

+ (simd_float4x4)float4x4FromFloatRotationXAngle:(float)angle {
    simd_float4x4 result = matrix_identity_float4x4;
    result.columns[1].y = cosf(angle);
    result.columns[1].z = sinf(angle);
    result.columns[2].y = -sinf(angle);
    result.columns[2].z = cosf(angle);
    
    return result;
}

+ (simd_float4x4)float4x4FromFloatRotationYAngle:(float)angle {
    simd_float4x4 result = matrix_identity_float4x4;
    result.columns[0].x = cosf(angle);
    result.columns[0].z = -sinf(angle);
    result.columns[2].x = sinf(angle);
    result.columns[2].z = cosf(angle);
    
    return result;
}

+ (simd_float4x4)float4x4FromFloatRotationZAngle:(float)angle {
    simd_float4x4 result = matrix_identity_float4x4;
    result.columns[0].x = cosf(angle);
    result.columns[0].y = sinf(angle);
    result.columns[1].x = -sinf(angle);
    result.columns[1].y = cosf(angle);
    
    return result;
}

+ (simd_float4x4)float4x4FromFloat3RotationAngle:(simd_float3)angle {
    simd_float4x4 rotationX = [self float4x4FromFloatRotationXAngle:angle.x];
    simd_float4x4 rotationY = [self float4x4FromFloatRotationYAngle:angle.y];
    simd_float4x4 rotationZ = [self float4x4FromFloatRotationZAngle:angle.z];
    
    return matrix_multiply(matrix_multiply(rotationX, rotationY), rotationZ);
}

+ (simd_float4x4)float4x4FromFloat3RotationYXZAngle:(simd_float3)angle {
    simd_float4x4 rotationX = [self float4x4FromFloatRotationXAngle:angle.x];
    simd_float4x4 rotationY = [self float4x4FromFloatRotationYAngle:angle.y];
    simd_float4x4 rotationZ = [self float4x4FromFloatRotationZAngle:angle.z];
    
    return matrix_multiply(matrix_multiply(rotationY, rotationX), rotationZ);
}

+ (simd_float3x3)upperLeftFloat3x3FromFloat4x4:(simd_float4x4)float4x4 {
    simd_float3x3 result = matrix_identity_float3x3;
    
    for (NSUInteger i = 0; i < 3; i++) {
        result.columns[i].x = float4x4.columns[i].x;
        result.columns[i].y = float4x4.columns[i].y;
        result.columns[i].z = float4x4.columns[i].z;
    }
    
    return result;
}

+ (simd_float4x4)float4x4FromProjectionFov:(float)fov near:(float)near far:(float)far aspect:(float)aspect lhs:(BOOL)lhs {
    float y = 1.f / tanf(fov * 0.5f);
    float x = y / aspect;
    float z = lhs ? (far / (far - near)) : (far / (near - far));
    simd_float4 X = simd_make_float4(x, 0.f, 0.f, 0.f);
    simd_float4 Y = simd_make_float4(0.f, y, 0.f, 0.f);
    simd_float4 Z = lhs ? simd_make_float4(0.f, 0.f, z, 1.f) : simd_make_float4(0.f, 0.f, z, -1.f);
    simd_float4 W = lhs ? simd_make_float4(0.f, 0.f, z * -near, 0.f) : simd_make_float4(0.f, 0.f, z * near, 0.f);
    
    simd_float4x4 result = matrix_identity_float4x4;
    result.columns[0] = X;
    result.columns[1] = Y;
    result.columns[2] = Z;
    result.columns[3] = W;
    
    return result;
}

+ (simd_float4x4)float4x4FromProjectionFov:(float)fov near:(float)near far:(float)far aspect:(float)aspect {
    return [self float4x4FromProjectionFov:fov near:near far:far aspect:aspect lhs:YES];
}

+ (simd_float4x4)float4x4FromEye:(simd_float3)eye center:(simd_float3)center up:(simd_float3)up {
    simd_float3 z = simd_normalize(center - eye);
    simd_float3 x = simd_normalize(simd_cross(up, z));
    simd_float3 y = simd_cross(z, x);
    
    simd_float4 X = simd_make_float4(x.x, y.x, z.x, 0.f);
    simd_float4 Y = simd_make_float4(x.y, y.y, z.y, 0.f);
    simd_float4 Z = simd_make_float4(x.z, y.z, z.z, 0.f);
    simd_float4 W = simd_make_float4(-simd_dot(x, eye), -simd_dot(y, eye), -simd_dot(z, eye), 1.f);
    
    simd_float4x4 result = matrix_identity_float4x4;
    result.columns[0] = X;
    result.columns[1] = Y;
    result.columns[2] = Z;
    result.columns[3] = W;
    
    return result;
}

+ (simd_float4x4)float4x4FromOrthographic:(CGRect)rect near:(float)near far:(float)far {
    float left = rect.origin.x;
    float right = rect.origin.x + rect.size.width;
    float top = rect.origin.y;
    float bottom = rect.origin.y - rect.size.height;
    simd_float4 X = simd_make_float4(2.f / (right - left), 0.f, 0.f, 0.f);
    simd_float4 Y = simd_make_float4(0.f, 2.f / (top - bottom), 0.f, 0.f);
    simd_float4 Z = simd_make_float4(0.f, 0.f, 1.f / (far - near), 0.f);
    simd_float4 W = simd_make_float4(
                                     (left + right) / (left - right),
                                     (top + bottom) / (bottom - top),
                                     near / (near - far),
                                     1.f
                                     );
    
    simd_float4x4 result = matrix_identity_float4x4;
    result.columns[0] = X;
    result.columns[1] = Y;
    result.columns[2] = Z;
    result.columns[3] = W;
    
    return result;
}

+ (simd_float4x4)float4x4FromDouble4x4:(simd_double4x4)double4x4 {
    simd_float4x4 result = matrix_identity_float4x4;
    
    for (NSUInteger i = 0; i < 4; i++) {
        result.columns[i].x = double4x4.columns[i].x;
        result.columns[i].y = double4x4.columns[i].y;
        result.columns[i].z = double4x4.columns[i].z;
        result.columns[i].w = double4x4.columns[i].w;
    }
    
    return result;
}


+ (simd_float3x3)normalFloat3x3FromFloat4x4:(simd_float4x4)float4x4 {
    simd_float3x3 upperLeft = [self upperLeftFloat3x3FromFloat4x4:float4x4];
    simd_float3x3 inversed = simd_inverse(upperLeft);
    simd_float3x3 transposed = simd_transpose(inversed);
    
    return transposed;
}


+ (simd_float3)xyzFloat3FromFloat4:(simd_float4)float4 {
    return simd_make_float3(float4.x, float4.y, float4.z);
}


+ (simd_float3)float3FromDouble3:(simd_double3)double3 {
    return simd_make_float3(double3.x, double3.y, double3.z);
}

@end
