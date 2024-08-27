//
//  MathLibrary.m
//  Chapter6
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import "MathLibrary.h"

@implementation MathLibrary

+ (float)degreesFromRadians:(float)radians {
    return (radians / M_PI) * 180.0f;
}

+ (float)radiansFromDegrees:(float)degrees {
    return (degrees / 180.f) * M_PI;
}

+ (simd_float4x4)float4x4FromFloat3Translation:(simd_float3)translation {
    simd_float4x4 matrix;
    matrix.columns[0] = simd_make_float4(1.f, 0.f, 0.f, 0.f);
    matrix.columns[1] = simd_make_float4(0.f, 1.f, 0.f, 0.f);
    matrix.columns[2] = simd_make_float4(0.f, 0.f, 1.f, 0.f);
    matrix.columns[3] = simd_make_float4(translation, 1.f);
    
    return matrix;
}

+ (simd_float4x4)float4x4FromFloat3Scale:(simd_float3)scale {
    simd_float4x4 matrix;
    matrix.columns[0] = simd_make_float4(scale.x, 0.f, 0.f, 0.f);
    matrix.columns[1] = simd_make_float4(0.f, scale.y, 0.f, 0.f);
    matrix.columns[2] = simd_make_float4(0.f, 0.f, scale.z, 0.f);
    matrix.columns[3] = simd_make_float4(0.f, 0.f, 0.f, 1.f);
    
    return matrix;
}

+ (simd_float4x4)float4x4FromScale:(float)scale {
    simd_float4x4 matrix = matrix_identity_float4x4;
    matrix.columns[3].w /= scale;
    
    return matrix;
}

+ (simd_float4x4)float4x4FromRotationXAngle:(float)angle {
    simd_float4x4 matrix;
    matrix.columns[0] = simd_make_float4(1.f, 0.f, 0.f, 0.f);
    matrix.columns[1] = simd_make_float4(0.f, cos(angle), sin(angle), 0.f);
    matrix.columns[2] = simd_make_float4(0.f, -sin(angle), cos(angle), 0.f);
    matrix.columns[3] = simd_make_float4(0.f, 0.f, 0.f, 1.f);
    
    return matrix;
}

+ (simd_float4x4)float4x4FromRotationYAngle:(float)angle {
    simd_float4x4 matrix;
    matrix.columns[0] = simd_make_float4(cos(angle), 0.f, -sin(angle), 0.f);
    matrix.columns[1] = simd_make_float4(0.f, 1.f, 0.f, 0.f);
    matrix.columns[2] = simd_make_float4(sin(angle), 0.f, cos(angle), 0.f);
    matrix.columns[3] = simd_make_float4(0.f, 0.f, 0.f, 1.f);
    
    return matrix;
}

+ (simd_float4x4)float4x4FromRotationZAngle:(float)angle {
    simd_float4x4 matrix;
    matrix.columns[0] = simd_make_float4(cos(angle), sin(angle), 0.f, 0.f);
    matrix.columns[1] = simd_make_float4(-sin(angle), cos(angle), 0.f, 0.f);
    matrix.columns[2] = simd_make_float4(0.f, 0.f, 1.f, 0.f);
    matrix.columns[3] = simd_make_float4(0.f, 0.f, 0.f, 1.f);
    
    return matrix;
}

+ (simd_float4x4)float4x4FromRotationXYZAngle:(float)angle {
    simd_float4x4 rotationX = [MathLibrary float4x4FromRotationXAngle:angle];
    simd_float4x4 rotationY = [MathLibrary float4x4FromRotationYAngle:angle];
    simd_float4x4 rotationZ = [MathLibrary float4x4FromRotationZAngle:angle];
    
    return simd_mul(simd_mul(rotationX, rotationY), rotationZ);
}

+ (simd_float4x4)float4x4FromRotationYXZAngle:(float)angle {
    simd_float4x4 rotationX = [MathLibrary float4x4FromRotationXAngle:angle];
    simd_float4x4 rotationY = [MathLibrary float4x4FromRotationYAngle:angle];
    simd_float4x4 rotationZ = [MathLibrary float4x4FromRotationZAngle:angle];
    
    return simd_mul(simd_mul(rotationY, rotationX), rotationZ);
}

+ (simd_float3x3)upperLeftFloat3x3FromFloat4x4:(simd_float4x4)matrix {
    simd_float3x3 result;
    result.columns[0] = matrix.columns[0].xyz;
    result.columns[1] = matrix.columns[1].xyz;
    result.columns[2] = matrix.columns[2].xyz;
    
    return result;
}

+ (simd_float4x4)float4x4FromProjectionFov:(float)fov near:(float)near far:(float)far aspect:(float)aspect lhs:(BOOL)lhs {
    float y = 1 / tan(fov * 0.5f);
    float x = y / aspect;
    float z = lhs ? (far / (far - near)) : (far / (near - far));
    
    simd_float4x4 result;
    result.columns[0] = simd_make_float4(x, 0.f, 0.f, 0.f);
    result.columns[1] = simd_make_float4(0.f, y, 0.f, 0.f);
    result.columns[2] = simd_make_float4(0.f, 0.f, z, lhs ? 1.f : -1.f);
    result.columns[3] = simd_make_float4(0.f, 0.f, z * near * (lhs ? -1.f : 1.f), 0.f);
    
    return result;
}

+ (simd_float4x4)float4x4FromEye:(float)eye center:(simd_float3)center up:(simd_float3)up {
    simd_float3 z = simd_normalize(center - eye);
    simd_float3 x = simd_normalize(simd_cross(up, z));
    simd_float3 y = simd_cross(z, x);
    
    simd_float4x4 result;
    result.columns[0] = simd_make_float4(x.x, y.x, z.x, 0.f);
    result.columns[1] = simd_make_float4(x.y, y.y, z.y, 0.f);
    result.columns[2] = simd_make_float4(x.z, y.z, z.z, 0.f);
    result.columns[3] = simd_make_float4(-simd_dot(x, eye), -simd_dot(y, eye), -simd_dot(z, eye), 1.f);
    
    return result;
}

+ (simd_float4x4)float4x4FromOrthographicRect:(CGRect)rect near:(float)near far:(float)far {
    float left = CGRectGetMinX(rect);
    float right = CGRectGetMinX(rect) + CGRectGetWidth(rect);
    float top = CGRectGetMinY(rect);
    float bottom = CGRectGetMinY(rect) - CGRectGetHeight(rect);
    
    simd_float4x4 result;
    result.columns[0] = simd_make_float4(2.f / (right - left), 0.f, 0.f, 0.f);
    result.columns[1] = simd_make_float4(0.f, 2.f / (top - bottom), 0.f, 0.f);
    result.columns[2] = simd_make_float4(0.f, 0.f, 1.f / (far - near), 0.f);
    result.columns[3] = simd_make_float4((left + right) / (left - right),
                                         (top + bottom) / (bottom - top),
                                         near / (near - far),
                                         1.f);
    
    return result;
}

+ (simd_float4x4)float4x4FromDouble4x4:(simd_double4x4)matrix {
    simd_float4x4 result;
    result.columns[0] = simd_make_float4(matrix.columns[0].x, matrix.columns[0].y, matrix.columns[0].z, matrix.columns[0].w);
    result.columns[1] = simd_make_float4(matrix.columns[1].x, matrix.columns[1].y, matrix.columns[1].z, matrix.columns[1].w);
    result.columns[2] = simd_make_float4(matrix.columns[2].x, matrix.columns[2].y, matrix.columns[2].z, matrix.columns[2].w);
    result.columns[3] = simd_make_float4(matrix.columns[3].x, matrix.columns[3].y, matrix.columns[3].z, matrix.columns[3].w);
    
    return result;
}

+ (simd_float4)float4FromDouble4:(simd_double4)matrix {
    return simd_make_float4(matrix.x, matrix.y, matrix.z, matrix.w);
}

+ (simd_float3x3)float3x3FromNormalFloat4x4:(simd_float4x4)matrix {
    return simd_transpose(simd_inverse([MathLibrary upperLeftFloat3x3FromFloat4x4:matrix]));
}

@end
