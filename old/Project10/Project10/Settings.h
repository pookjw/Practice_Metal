//
//  Settings.h
//  Chapter8
//
//  Created by Jinwoo Kim on 5/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Settings : NSObject
@property (class, readonly, nonatomic) float rotationSpeed;
@property (class, readonly, nonatomic) float translationSpeed;
@property (class, readonly, nonatomic) float mouseScrollSensitivity;
@property (class, readonly, nonatomic) float moustPanSensitivity;
@property (class, readonly, nonatomic) float touchZoomSensitivity;
@end

NS_ASSUME_NONNULL_END
