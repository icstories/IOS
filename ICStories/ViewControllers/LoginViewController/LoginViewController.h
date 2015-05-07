//
//  ICStoriesViewController.h
//  ICStories
//
//  Created by Rahul Kalavar on 10/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrationViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ICStoriesAppDelegate.h"
#import "Reachability.h"
#import "BaseViewController.h"
#import "TACViewController.h"

/*============================================================================================*/
@interface LoginViewController : BaseViewController<UITextFieldDelegate,ICStoriesDelegate,UIAlertViewDelegate>
{

}

/*============================================================================================*/

- (IBAction)signUp:(id)sender;
- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)loginWithFB:(id)sender;
- (IBAction)forgotPassword:(id)sender;
- (IBAction)termsAndCondition:(id)sender;


/*============================================================================================*/

@property (weak, nonatomic) IBOutlet UIImageView *loginBackgroundImage;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

/*============================================================================================*/

-(void)facebookInfo:(NSString *)deviceToken withEmailID:(NSString *)emailID withUserName:(NSString *)username withZipCode:(NSString *)zipCode;

@end
