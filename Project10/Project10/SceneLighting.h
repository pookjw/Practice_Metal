//
//  SceneLighting.h
//  Project10
//
//  Created by Jinwoo Kim on 5/10/23.
//

#import <Foundation/Foundation.h>
#import "common.h"

NS_ASSUME_NONNULL_BEGIN

@interface SceneLighting : NSObject
@property (class, readonly, nonatomic) Light sunlight;
@property (class, readonly, nonatomic) Light ambientLight;
@property (class, readonly, nonatomic) Light redLight;
@property (strong, readonly) NSMutableArray<NSValue *> *lights;
+ (Light)buildDefaultLight;
- (Light *)lightsDataWithCount:(NSUInteger * _Nullable)count; // have to free()
@end

NS_ASSUME_NONNULL_END
