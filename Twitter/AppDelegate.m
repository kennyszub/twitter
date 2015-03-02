//
//  AppDelegate.m
//  Twitter
//
//  Created by Ken Szubzda on 2/19/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "TweetsViewController.h"
#import "ContainerViewController.h"
#import "MenuViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // setup logout observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:UserDidLogoutNotification object:nil];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ContainerViewController *cvc;
    MenuViewController *mvc = [[MenuViewController alloc] init];
    UINavigationController *nvc;
    User *user = [User currentUser];
    if (user != nil) {
        NSLog(@"Welcome %@", user.name);
        TweetsViewController *tvc = [[TweetsViewController alloc] initWithHomeTimeline];
        nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
        cvc = [[ContainerViewController alloc] initWithMenuView:mvc contentView:nvc];
//        tvc.delegate = cvc;
        self.window.rootViewController = cvc;
    } else {
        NSLog(@"Not logged in");
        LoginViewController *lvc = [[LoginViewController alloc] init];
        self.window.rootViewController = lvc;
    }
    
    [self.window makeKeyAndVisible];
    
    // set navigation bar colors
    [[UINavigationBar appearance] setBarTintColor:[[UIColor alloc] initWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];

    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)userDidLogout {
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ self.window.rootViewController = [[LoginViewController alloc] init]; }
                    completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[TwitterClient sharedInstance] openURL:url];
    
    return YES;
}

@end
