//
//  PGAppDelegate.m
//  Ping
//
//  Created by Shoumik Palkar on 2/12/14.
//  Copyright (c) 2014 Shoumik Palkar. All rights reserved.
//

#import "PGAppDelegate.h"
#import "PGViewController.h"

@implementation PGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.viewController = [[PGViewController alloc] initWithNibName:@"PGViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self.viewController stopPings];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.viewController startPings];
}

@end
