//
//  AppDelegate.m
//  Project10
//
//  Created by Jinwoo Kim on 5/7/23.
//

#import "AppDelegate.h"
#import "SceneDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    UISceneConfiguration *configuration = connectingSceneSession.configuration;
    configuration.delegateClass = SceneDelegate.class;
    return configuration;
}

@end
