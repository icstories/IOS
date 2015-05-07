//
//  SettingsViewController.m
//  ICStories
//
//  Created by demo on 11/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>

/*============================================================================================*/

@interface SettingsViewController ()

@end

/*============================================================================================*/

@implementation SettingsViewController

/*============================================================================================*/

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];
}

/*============================================================================================*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([UIScreen mainScreen].bounds.size.height > 500)
    {
        ((UIImageView *)[self.view viewWithTag:231]).image = [UIImage imageNamed:@"login_bg5"];
    }
    else
        ((UIImageView *)[self.view viewWithTag:231]).image = [UIImage imageNamed:@"login_bg"];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Resolution"] isEqualToString:@"AVCaptureSessionPreset352x288"])
    {
        [self.firstResolution setBackgroundImage:[UIImage imageNamed:@"SelectedMark"] forState:UIControlStateNormal];

    }
    else
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Resolution"] isEqualToString:@"AVCaptureSessionPreset640x480"])
    {
        [self.secondResolution setBackgroundImage:[UIImage imageNamed:@"SelectedMark"] forState:UIControlStateNormal];

    }
    else
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Resolution"] isEqualToString:@"AVCaptureSessionPreset1920x1080"])
    {
        [self.thirdResolution setBackgroundImage:[UIImage imageNamed:@"SelectedMark"] forState:UIControlStateNormal];
    }
    
    [self.resolutionView addTarget:self action:@selector(backgroundTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.resolutionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BlackBackground.png"]];
    
    self.resolutionView.hidden = YES;
    self.resolutionView.frame = [UIScreen mainScreen].bounds;
    
    self.oldPasswordTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    [self.oldPasswordTextfield setValue:[UIColor darkGrayColor]
                          forKeyPath:@"_placeholderLabel.textColor"];
    
    ((UITextField *)[self.view viewWithTag:12]).layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    [((UITextField *)[self.view viewWithTag:12]) setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

/*============================================================================================*/

-(void)backgroundTapped
{
    self.resolutionView.frame = [UIScreen mainScreen].bounds;
    
    [UIView beginAnimations:@"Up" context:nil];
    [UIView setAnimationDuration:0.5];
    self.resolutionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height);
    [UIView commitAnimations];
}

/*============================================================================================*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

/*============================================================================================*/

- (IBAction)changePassword:(id)sender
{
    if ([self.oldPasswordTextfield.text isEqualToString:@""] || [((UITextField *)[self.view viewWithTag:12]).text isEqualToString:@""])
    {
        UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please fill the required fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    if (((UITextField *)[self.view viewWithTag:12]).text.length < 4)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Password length should be within 4 to 10" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        [indicatorMainView setHidden:NO];
        [activityIndicator startAnimating];
        [self performSelector:@selector(setNewPassword) withObject:nil afterDelay:0.2];
    }
}

/*============================================================================================*/

-(void)setNewPassword
{

    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.icstories.com/icstories/webservices/users/change_password"]]; //Live server
    [theRequest setTimeoutInterval:60];
    
    NSString *oldPassWord= self.oldPasswordTextfield.text;
    const char *cStr = [oldPassWord UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *oldOutput = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [oldOutput appendFormat:@"%02x", digest[i]];
    }
    
    NSString *newPassword = ((UITextField *)[self.view viewWithTag:12]).text;
    const char *newCStr = [newPassword UTF8String];
    unsigned char newDigest[16];
    CC_MD5( newCStr, strlen(newCStr), newDigest ); // This is the md5 call
    
    NSMutableString *newOutput = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [newOutput appendFormat:@"%02x", newDigest[i]];
    }
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"change_password" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //new password
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"new_password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[newOutput dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // old Password
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"old_password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[oldOutput dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSArray *userIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
    //
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[[userIds objectAtIndex:0] objectForKey:@"user_id"] dataUsingEncoding:NSUTF8StringEncoding ]];
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
        [indicatorMainView setHidden:YES];
        [activityIndicator stopAnimating];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:nil  delegate:nil  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        UIAlertView *alet = [[UIAlertView alloc] initWithTitle:nil message:returnString delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alet show];
        if ([returnString rangeOfString:@"success"].location == NSNotFound)
        {
            alert.message = @"Password is not Updated.";
            self.oldPasswordTextfield.text = @"";
            ((UITextField *)[self.view viewWithTag:12]).text = @"";
        }
        else
        {
            alert.message = @"Password updated Successfully!";
        }
        self.oldPasswordTextfield.text = @"";
        ((UITextField *)[self.view viewWithTag:12]).text = @"";
        [alert show];
    }
}
/*============================================================================================*/

- (IBAction)logOut:(id)sender
{

    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"data"];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"IsUploadingStarted"] == 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You can not logout. Video is getting uploaded. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        [self performSelector:@selector(userLogOut) withObject:nil afterDelay:0.2];
        [activityIndicator startAnimating];
        [indicatorMainView setHidden:NO];
    }
}

/*============================================================================================*/

-(void)userLogOut
{
//    ICStoriesAppDelegate *delegate = (ICStoriesAppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://bizmoapps.com/icstories/webservices/users/logout"]]; //Live server
//    [theRequest setTimeoutInterval:60];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//    [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
//    
//    NSMutableData *body = [NSMutableData data];
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"change_password" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    NSArray *userIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
//    
//    //dev token
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"dev_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[delegate.loggedInDeviceToken dataUsingEncoding:NSUTF8StringEncoding ]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //user id
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[[userIds objectAtIndex:0] objectForKey:@"userid"] dataUsingEncoding:NSUTF8StringEncoding ]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [theRequest setHTTPMethod:@"POST"];
//    [theRequest setHTTPBody:body];
//    
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
//    if (!internetStatus)
//    {
//        [activityIndicator stopAnimating];
//        [indicatorMainView setHidden:YES];
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have no internet connection please check" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//    }
//    else
//    {
//        [activityIndicator stopAnimating];
//        [indicatorMainView setHidden:YES];
//        NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
//        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//        
//        NSData *jsonData = [returnString dataUsingEncoding:NSUTF8StringEncoding];
//        
//        NSError *error = nil;
//        NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:nil  delegate:nil  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        
//        if ([[myDictionary objectForKey:@"statusInfo"] isEqualToString:@"success"])
//        {
//
//            ICStoriesAppDelegate *appDelegate= (ICStoriesAppDelegate*)[[UIApplication sharedApplication] delegate];
//            UIViewController *initViewController = [self.storyboard instantiateInitialViewController];
//            [appDelegate.window setRootViewController:initViewController];
//            alert.message = @"Logged Out Successfully!";
//        }
//        else
//        {
//            alert.message = @"Logout Unsuccessfull!";
//            
//        }
//        [alert show];
//
//    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:nil  delegate:nil  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Resolution"];

    ICStoriesAppDelegate *appDelegate= (ICStoriesAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIViewController *initViewController = [self.storyboard instantiateInitialViewController];
    [appDelegate.window setRootViewController:initViewController];
    alert.message = @"Logged Out Successfully!";

}

/*============================================================================================*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.oldPasswordTextfield == textField)
    {
        [self.oldPasswordTextfield resignFirstResponder];
        [((UITextField *)[self.view viewWithTag:12]) becomeFirstResponder];
    }
    else
    {
        [((UITextField *)[self.view viewWithTag:12]) resignFirstResponder];
    }
    return YES;
}

/*============================================================================================*/

- (IBAction)selectResolution:(id)sender
{
    self.resolutionView.hidden = NO;
    self.resolutionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height);
    
    [UIView beginAnimations:@"Up" context:nil];
    [UIView setAnimationDuration:0.5];
    self.resolutionView.frame = [UIScreen mainScreen].bounds;
    [UIView commitAnimations];
    
}

/*============================================================================================*/

- (IBAction)firstResolution:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"AVCaptureSessionPreset352x288" forKey:@"Resolution"];

    [self.firstResolution setBackgroundImage:[UIImage imageNamed:@"SelectedMark"] forState:UIControlStateNormal];
    [self.secondResolution setBackgroundImage:nil forState:UIControlStateNormal];
    [self.thirdResolution setBackgroundImage:nil forState:UIControlStateNormal];

}

/*============================================================================================*/

- (IBAction)secondResolution:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"AVCaptureSessionPreset640x480" forKey:@"Resolution"];

    [self.secondResolution setBackgroundImage:[UIImage imageNamed:@"SelectedMark"] forState:UIControlStateNormal];
    [self.firstResolution setBackgroundImage:nil forState:UIControlStateNormal];
    [self.thirdResolution setBackgroundImage:nil forState:UIControlStateNormal];

}

/*============================================================================================*/

- (IBAction)thirdResolution:(id)sender
{
    if(![UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Front camera does not support this resolution" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"AVCaptureSessionPreset1920x1080" forKey:@"Resolution"];
    }
    [self.thirdResolution setBackgroundImage:[UIImage imageNamed:@"SelectedMark"] forState:UIControlStateNormal];
    [self.secondResolution setBackgroundImage:nil forState:UIControlStateNormal];
    [self.firstResolution setBackgroundImage:nil forState:UIControlStateNormal];
}

/*============================================================================================*/

@end
