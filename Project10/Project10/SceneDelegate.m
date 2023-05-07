//
//  SceneDelegate.m
//  Project10
//
//  Created by Jinwoo Kim on 5/7/23.
//

#import "SceneDelegate.h"
#import "ViewController.h"

@interface SceneDelegate ()
@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    window.rootViewController = [ViewController new];
    [window makeKeyAndVisible];
    self.window = window;
}

@end
