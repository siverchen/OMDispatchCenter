//
//  AppDelegate.m
//  OMDispatchCenter
//
//  Created by Chen Lei on 13-3-12.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import "AppDelegate.h"
#import "OMSong.h"
#import "OMDispatchCenter.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (void)go:(UIButton *)sender{
    if (sender.tag == 0){
        [_center addSong:_song];
        sender.tag = 1;
    }else{
        [_center closeSong:_song];
        sender.tag = 0;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    _center = [[OMDispatchCenter alloc] init];
    
    
    _song = [[OMSong alloc] init];
    [_song setSongid:@"1530612"];
    
    
    _viewController = [[UIViewController alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0, 100, 100, 100)];
    
    [_viewController.view addSubview:button];
    button.tag = 0;
    [button addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
    [self.window setRootViewController:_viewController];
    
    return YES;
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
