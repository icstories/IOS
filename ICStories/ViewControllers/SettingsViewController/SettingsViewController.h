//
//  SettingsViewController.h
//  ICStories
//
//  Created by demo on 11/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "ICStoriesAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Reachability.h"
#import "BaseViewController.h"

/*============================================================================================*/

@interface SettingsViewController : BaseViewController<UIAlertViewDelegate>

/*============================================================================================*/

- (IBAction)firstResolution:(id)sender;
- (IBAction)secondResolution:(id)sender;
- (IBAction)thirdResolution:(id)sender;
- (IBAction)selectResolution:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *firstResolution;
@property (weak, nonatomic) IBOutlet UIButton *secondResolution;
@property (weak, nonatomic) IBOutlet UIButton *thirdResolution;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextfield;
@property (weak, nonatomic) IBOutlet UIControl *resolutionView;

/*============================================================================================*/

@end
