//
//  Camera.h
//  Chapter8
//
//  Created by Jinwoo Kim on 5/3/23.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Transform.h"

NS_ASSUME_NONNULL_BEGIN

@protocol Camera <Transformable>
@property (readonly, nonatomic) simd_float4x4 projectionMatrix;
@property (readonly, nonatomic) simd_float4x4 viewMatrix;
- (void)updateWithSize:(CGSize)size;
- (void)updateWithDeltaTime:(float)deltaTime;
@end

NS_ASSUME_NONNULL_END
