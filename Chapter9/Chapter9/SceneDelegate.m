//
//  SceneDelegate.m
//  Chapter9
//
//  Created by Jinwoo Kim on 9/21/24.
//

#import "SceneDelegate.h"
#import "ViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    
    ViewController *viewController = [ViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [viewController release];
    
    window.rootViewController = navigationController;
    [navigationController release];
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end
