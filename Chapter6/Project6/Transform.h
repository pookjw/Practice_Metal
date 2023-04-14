//
//  Transform.h
//  Project6
//
//  Created by Jinwoo Kim on 4/14/23.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@class Transform;
@protocol Transformable <NSObject>
@property (readonly) Transform *transform;
@end

@interface Transform : NSObject
@property simd_float3 position;
@property simd_float3 rotation;
@property float scale;

@property (readonly, nonatomic) matrix_float4x4 modelMatrix;
@end

NS_ASSUME_NONNULL_END
