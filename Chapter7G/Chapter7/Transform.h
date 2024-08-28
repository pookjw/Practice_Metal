//
//  Transform.h
//  Chapter6
//
//  Created by Jinwoo Kim on 8/28/24.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface Transform : NSObject {
@public simd_float3 _position;
@public simd_float3 _rotation;
@public float _scale;
}
@property (assign, readonly, nonatomic) simd_float4x4 modelMatrix;
@end

NS_ASSUME_NONNULL_END
