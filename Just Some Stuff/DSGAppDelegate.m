//
//  TGOAppDelegate.m
//  Just Some Stuff
//
//  Created by MacBrian Pro on 30/03/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGAppDelegate.h"

@implementation DSGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //[[FlickrKit sharedFlickrKit] initializeWithAPIKey:@"1d6aa108698333d0f168ecdbc0842b0b" sharedSecret:@"9a5498c3e69fdacb"];
    
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:@"682e15dd33987184901839a79274887c" sharedSecret:@"1fcbd998a9019980"];
    
    /*
    [[FlickrKit sharedFlickrKit] beginAuthWithCallbackURL:[NSURL URLWithString:@"com.unlimited.thatguy"] permission:FKPermissionRead completion:^(NSURL *flickrLoginPageURL, NSError *error) {
        [[UIApplication sharedApplication] openURL:flickrLoginPageURL];
    }];
    
    [[FlickrKit sharedFlickrKit] completeAuthWithURL:[NSURL URLWithString:@"com.unlimited.thatguy"] completion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        NSLog(@"Logged in as %@, %@, %@", userName, userId, fullName);
    }];
    */
    
    _window.tintColor = [UIColor colorWithRed:6.0/255.0 green:94.0/255.0 blue:79.0/255.0 alpha:1.0f];
    
    
    return YES;
}

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *scheme = [url scheme];
	if([@"dsgnrsstudio" isEqualToString:scheme])
    {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthCallbackNotification" object:url userInfo:nil];
    }
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
