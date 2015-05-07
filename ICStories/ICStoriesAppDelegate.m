//
//  ICStoriesAppDelegate.m
//  ICStories
//
//  Created by Rahul Kalavar on 10/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import "ICStoriesAppDelegate.h"

/*============================================================================================*/

@implementation ICStoriesAppDelegate

/*============================================================================================*/

@synthesize loggedInDeviceToken;

/*============================================================================================*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }else
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    return YES;
}

/*============================================================================================*/


// Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@",devToken];
    
    deviceTokenString = [deviceTokenString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.loggedInDeviceToken = deviceTokenString;
    
}

/*============================================================================================*/

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground)
    {
        UIAlertView *showAlert = [[UIAlertView alloc] initWithTitle:@"Update your app with a new assignment" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [showAlert show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"New_Assignment" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AssignmentAdded" object:nil];
    }
}

/*============================================================================================*/

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

/*============================================================================================*/

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

/*============================================================================================*/

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            nil];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:allowLoginUI completionHandler:^(FBSession *session,
                                                                                                                     FBSessionState state,
                                                                                                                     NSError *error)
            {
                [self sessionStateChanged:session
                                    state:state
                                    error:error];
            }];
    
}

/*============================================================================================*/

#pragma -mark
#pragma -mark Facebook
#pragma -mark

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
            
            
        case FBSessionStateOpen:
            if (!error)
            {
                [FBRequestConnection
                 startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                   NSDictionary<FBGraphUser> *user,
                                                   NSError *error)
                 {
                     if (!error)
                     {
                        // NSLog(@"%@",user);
                         [self.delegate sendEmailIdAndFacebookToken:[user objectForKey:@"id"] withEmailID:[user objectForKey:@"email"] withUserName:[user objectForKey:@"name"] ];

                        self.loggedInSession = FBSession.activeSession;
                     }
                 }];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    if (error)
    {
        [self openSessionWithAllowLoginUI:YES];
    }
}

/*============================================================================================*/


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlString = url.absoluteString;
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"access_token=(.*)&" options:0 error:&error];
    if (regex != nil)
    {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch)
        {
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *googleRequestURL=[NSURL URLWithString:[[NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", [accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
            
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];

            [self.delegate sendEmailIdAndFacebookToken:accessToken withEmailID:[json objectForKey:@"email"] withUserName:[json objectForKey:@"name"]];

        }
    }
    return YES;
}

/*============================================================================================*/

@end
