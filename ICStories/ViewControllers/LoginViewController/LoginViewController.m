//
//  ICStoriesViewController.m
//  ICStories
//
//  Created by Rahul Kalavar on 10/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>

/*============================================================================================*/

@interface LoginViewController ()
{
    NSString *fb_Name;
    NSString *fb_Token;
    NSString *fb_EmailId;
}
@end

/*============================================================================================*/

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.navigationController.navigationBar.hidden = YES;
    
    //[self.userNameTextField becomeFirstResponder];
    
    if ([UIScreen mainScreen].bounds.size.height > 500)
        
        self.loginBackgroundImage.image = [UIImage imageNamed:@"LoginBackground_5.png"];
    else
        self.loginBackgroundImage.image = [UIImage imageNamed:@"login_bg.png"];
    
    self.userNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    [self.userNameTextField setValue:[UIColor darkGrayColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.passwordTextField setValue:[UIColor darkGrayColor]
                          forKeyPath:@"_placeholderLabel.textColor"];
}

/*============================================================================================*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.loginBackgroundImage = nil;
}

/*============================================================================================*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.userNameTextField == textField)
    {
        [self.userNameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        [self.passwordTextField resignFirstResponder];
    }

    return YES;
}

/*============================================================================================*/

- (IBAction)signUp:(id)sender
{
    RegistrationViewController *registrationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:registrationVC];
    [self presentViewController:navController animated:YES completion:NULL];
}

/*============================================================================================*/

- (IBAction)loginButtonClicked:(id)sender
{
    [self.passwordTextField resignFirstResponder];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange range = [self.passwordTextField.text rangeOfCharacterFromSet:whitespace];
    if (range.location != NSNotFound)
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Password have blank space" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    if ([self.userNameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please fill the required fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        [indicatorMainView setHidden:NO];
        [activityIndicator startAnimating];
        [self performSelector:@selector(login) withObject:nil afterDelay:0.2];
    }

}

-(void)login
{
    ICStoriesAppDelegate *delegate = (ICStoriesAppDelegate *)[[UIApplication sharedApplication] delegate];

   // NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://bizmoapps.com/icstories/webservices/users/login"]];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.icstories.com/icstories/webservices/users/login"]];//Live server
    [theRequest setTimeoutInterval:60];

    NSString *passWord= self.passwordTextField.text;
    const char *cStr = [passWord UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }

    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];

    NSMutableData *body = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"login" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    //username
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.userNameTextField.text dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    //Password
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[output dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    //input_from_dev
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"input_from_dev\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"IOS" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"dev_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[delegate.loggedInDeviceToken dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:body];

    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (!internetStatus)
    {
        [indicatorMainView setHidden:YES];
        [activityIndicator stopAnimating];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have no internet connection please check" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:nil  delegate:nil  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        UIAlertView *alet = [[UIAlertView alloc] initWithTitle:nil message:returnString delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alet show];
        NSData *jsonData = [returnString dataUsingEncoding:NSUTF8StringEncoding];

        NSError *error = nil;
        NSMutableDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

        if (((NSArray*)[myDictionary objectForKey:@"assignment_info"]).count != 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[myDictionary objectForKey:@"assignment_info"] forKey:@"assignment_info"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"assignment_info"];
        }
        
        if ([[myDictionary objectForKey:@"statusInfo"] isEqualToString:@"success"])
        {
            [indicatorMainView setHidden:YES];
            [activityIndicator stopAnimating];
            [[NSUserDefaults standardUserDefaults] setObject:[myDictionary objectForKey:@"ids"] forKey:@"UserId"];
            UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabbarController"];
            [self.navigationController pushViewController:tabBarController animated:YES];
        }
        else
        {
            [indicatorMainView setHidden:YES];
            [activityIndicator stopAnimating];
            alert.message = @"The email or password you entered is incorrect.";
            [alert show];
        }
    }
}

//Facebook
/*============================================================================================*/

- (IBAction)loginWithFB:(id)sender
{
    ICStoriesAppDelegate *appDelegate = (ICStoriesAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.delegate = self;
    [appDelegate openSessionWithAllowLoginUI:YES];
}

/*============================================================================================*/

- (IBAction)forgotPassword:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter your email id?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    alert.tag = 203;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

/*============================================================================================*/

- (IBAction)termsAndCondition:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 100)
    {
        TACViewController *tandC = [self.storyboard instantiateViewControllerWithIdentifier:@"TACViewController"];
        tandC.isThatTaC = YES;
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        [self.navigationController pushViewController:tandC animated:YES];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }
    else if(button.tag == 101)
    {
        TACViewController *tandC = [self.storyboard instantiateViewControllerWithIdentifier:@"TACViewController"];
        tandC.isThatTaC = NO;
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        [self.navigationController pushViewController:tandC animated:YES];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }
}

/*============================================================================================*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (alertView.tag == 203)
        {
            NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.icstories.com/icstories/webservices/users/forgot_password"]]; //Live server
            [theRequest setTimeoutInterval:60];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"forgot_password" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            //username
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[alertView textFieldAtIndex:0].text dataUsingEncoding:NSUTF8StringEncoding ]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setHTTPBody:body];
            
            NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
            NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            //        UIAlertView *alet = [[UIAlertView alloc] initWithTitle:nil message:returnString delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            //        [alet show];
            NSData *jsonData = [returnString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *error = nil;
            NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            if ([[myDictionary objectForKey:@"statusInfo"] isEqualToString:@"success"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please check your mail"  delegate:nil  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This email is not valid. Please try again"  delegate:nil  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else if(alertView.tag == 56)
        {
            if ([[alertView textFieldAtIndex:0].text length] != 5)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Zipcode should have 5 digit" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else
            {
                
                [self facebookInfo:fb_Token withEmailID:fb_EmailId withUserName:fb_Name withZipCode:[alertView textFieldAtIndex:0].text];
            }

        }
    }
    
 }

/*============================================================================================*/

-(void)facebookInfo:(NSString *)deviceToken withEmailID:(NSString *)emailID withUserName:(NSString *)username withZipCode:(NSString *)zipCode
{
   // NSLog(@"sfsf");
    ICStoriesAppDelegate *delegate = (ICStoriesAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.icstories.com/icstories/webservices/users/registration"]]; //Live server
    [theRequest setTimeoutInterval:60];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"register" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //username
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //username
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fb_username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[username dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Password
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //email
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[emailID dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //zipcode
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"zipcode\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[zipCode dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //dev_token
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"dev_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[delegate.loggedInDeviceToken dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //input_from_dev
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"input_from_dev\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"IOS" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //login_type
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"login_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"FB" dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //fb_token
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fb_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[deviceToken dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:nil  delegate:nil  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    NSData *jsonData = [returnString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    [[NSUserDefaults standardUserDefaults] setObject:[myDictionary objectForKey:@"ids"] forKey:@"UserId"];
    if (((NSArray*)[myDictionary objectForKey:@"assignment_info"]).count != 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[myDictionary objectForKey:@"assignment_info"] forKey:@"assignment_info"];
    }
    if ([[myDictionary objectForKey:@"statusInfo"] isEqualToString:@"success"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Welcome, %@ you are logged in with facebook",username] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
        UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabbarController"];
        [self.navigationController pushViewController:tabBarController animated:YES];
    }
    else
    {
        alert.message = @"The email or password you entered is incorrect.";
        [alert show];
    }

}

/*============================================================================================*/

-(void)sendEmailIdAndFacebookToken:(NSString *)deviceToken withEmailID:(NSString *)emailID withUserName:(NSString *)username
{
    fb_Name = username;
    fb_Token = deviceToken;
    fb_EmailId = emailID;
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter zip code." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    alert.tag = 56;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"Please enter zip code";
    [alert textFieldAtIndex:0].keyboardType  = UIKeyboardTypeNumberPad;
    [alert show];
    

}

/*============================================================================================*/

@end
