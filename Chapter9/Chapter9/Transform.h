//
//  Transform.h
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface Transform : NSObject {
    simd_float3 _position;
    simd_float3 _rotation;
    float _scale;
}
@property (nonatomic, readonly) matrix_float4x4 modelMatrix;
@end

NS_ASSUME_NONNULL_END
