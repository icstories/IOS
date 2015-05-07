//
//  RegistrationViewController.h
//  ICStories
//
//  Created by Rahul Kalavar on 10/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "ICStoriesAppDelegate.h"
#import "Reachability.h"
#import "BaseViewController.h"
/*============================================================================================*/

@interface RegistrationViewController : BaseViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    UIToolbar *keyboardToolbar;
}

/*============================================================================================*/

@property(nonatomic, strong) UIToolbar *keyboardToolbar;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *zipCode;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

/*============================================================================================*/

- (IBAction)doneRegistration:(id)sender;

/*============================================================================================*/

@end
