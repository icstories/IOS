//
//  ICStoriesAppDelegate.h
//  ICStories
//
//  Created by Rahul Kalavar on 10/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

/*============================================================================================*/

@protocol ICStoriesDelegate;

@interface ICStoriesAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString          *loggedInDeviceToken;
}

/*============================================================================================*/

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString  *loggedInDeviceToken;
@property (nonatomic, weak) id<ICStoriesDelegate> delegate;
@property (strong, nonatomic) FBSession *loggedInSession;

/*============================================================================================*/

-(BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

/*============================================================================================*/

@end

/*============================================================================================*/

@protocol ICStoriesDelegate

@optional

-(void)sendEmailIdAndFacebookToken:(NSString *)deviceToken withEmailID:(NSString *)emailID withUserName:(NSString *)username;

@end

/*============================================================================================*/
