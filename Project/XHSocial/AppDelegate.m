//
//  AppDelegate.m
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-5.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import "AppDelegate.h"
#import "XHLoginViewController.h"
#import "TimelineTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [NimbleStore nb_setupStore:nil];
    
    User *loginUser = [User nb_findFirst];
    if (loginUser) {
        [self _setupTimelineViewControllerForRootViewController:loginUser];
    } else {
        [self _setupLoginViewControllerForRootViewController];
    }

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)_setupLoginViewControllerForRootViewController {
    XHLoginViewController *loginViewController = [[XHLoginViewController alloc] init];
    loginViewController.loginCompleted = ^(User *loginUser, UIViewController *didLoginCompleteViewController) {
        [self _setupTimelineViewControllerForRootViewController:loginUser];
    };
    MenuNavigationController *navigationController = [[MenuNavigationController alloc] initWithRootViewController:loginViewController];
    self.window.rootViewController = navigationController;
}

- (void)_setupTimelineViewControllerForRootViewController:(User *)loginUser {
    TimelineTableViewController *timelineTableViewController = [[TimelineTableViewController alloc] init];
    timelineTableViewController.loginUser = loginUser;
    MenuNavigationController *navigationController = [[MenuNavigationController alloc] initWithRootViewController:timelineTableViewController];
    self.window.rootViewController = navigationController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

@end
