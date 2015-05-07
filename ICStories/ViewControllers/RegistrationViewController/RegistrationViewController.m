//
//  RegistrationViewController.m
//  ICStories
//
//  Created by Rahul Kalavar on 10/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import <QuartzCore/QuartzCore.h>
#import "RegistrationViewController.h"

/*============================================================================================*/

@interface RegistrationViewController ()

@end

/*============================================================================================*/

@implementation RegistrationViewController

/*============================================================================================*/

@synthesize keyboardToolbar = keyboardToolbar;

/*============================================================================================*/

#define FIELDS_COUNT  4

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton setFrame:CGRectMake(0.0f, 0.0f, 60.0f, 30.0f)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(cancelRegistration:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 0.0f)];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[[UIImage imageNamed:@"CancelButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = doneBarButton;
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Navigationbar"] forBarMetrics:UIBarMetricsDefault];
    
    self.userName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.password.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.zipCode.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    [self.userName setValue:[UIColor darkGrayColor]
                          forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.password setValue:[UIColor darkGrayColor]
                          forKeyPath:@"_placeholderLabel.textColor"];
    [self.emailTextField setValue:[UIColor darkGrayColor]
                 forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.zipCode setValue:[UIColor darkGrayColor]
                 forKeyPath:@"_placeholderLabel.textColor"];
    
    
    if (self.keyboardToolbar == nil)
    {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
        self.keyboardToolbar.barStyle=UIBarStyleBlack;
        
        UIBarButtonItem *previousBarItem;
        UIBarButtonItem *nextBarItem;
        if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
        {
            previousBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(previousField:)];
            nextBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                            style:UIBarButtonItemStyleBordered
                                                           target:self
                                                           action:@selector(nextField:)];

        }else
        {
            previousBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(previousField:)];
            nextBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(nextField:)];
        }
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
        
        self.userName.inputAccessoryView = self.keyboardToolbar;
        self.password.inputAccessoryView = self.keyboardToolbar;
        self.emailTextField.inputAccessoryView = self.keyboardToolbar;
        self.zipCode.inputAccessoryView = self.keyboardToolbar;
    }
}

/*==================================================================================================*/

-(void)cancelRegistration:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*==================================================================================================*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    self.password = nil;
    self.userName = nil;
    self.zipCode = nil;
    self.emailTextField = nil;
}

/*==================================================================================================*/

- (IBAction)doneRegistration:(id)sender
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange range = [self.password.text rangeOfCharacterFromSet:whitespace];
    if ([self.userName.text isEqualToString:@""] || [self.password.text isEqualToString:@""] || [self.zipCode.text isEqualToString:@""] || [self.emailTextField.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please fill all required field" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    if (range.location != NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Password have blank space" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    if (self.userName.text.length < 4 || self.userName.text.length > 20)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Username length should be within 4 to 20" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    if (self.password.text.length < 4 || self.password.text.length > 10)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Password length should be within 4 to 10" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    if(![self validateEmailWithString:self.emailTextField.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Email should be in format:abc@gmail.com" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if([self.userName.text isEqualToString:@""] || [self.password.text isEqualToString:@""] || [self.emailTextField.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please fill the required fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if(self.zipCode.text.length != 5)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Zip code should have 5 digit" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        [activityIndicator startAnimating];
        [indicatorMainView setHidden:NO];
        [self performSelector:@selector(doRegistration) withObject:nil afterDelay:0.2];
    }

}

-(void)doRegistration
{
    ICStoriesAppDelegate *delegate = (ICStoriesAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.icstories.com/icstories/webservices/users/registration"]];
    [theRequest setTimeoutInterval:60];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSString *passWord= self.password.text;
    const char *cStr = [passWord UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"register" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //username
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.userName.text dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
   //fb_username
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fb_username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Password
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[output dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //email
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.emailTextField.text dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //zipcode
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"zipcode\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.zipCode.text dataUsingEncoding:NSUTF8StringEncoding]];
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
    [body appendData:[@"APP" dataUsingEncoding:NSUTF8StringEncoding ]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //fb_token
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fb_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
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
            UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabbarController"];
            [self.navigationController pushViewController:tabBarController animated:YES];
        }
        else
        {
            alert.message = @"Registration is not Successful!";
            [alert show];
        }
    }
}

/*==================================================================================================*/

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = YES;
    
}

/*============================================================================================*/

#pragma mark -
#pragma mark - email validation
#pragma mark -


- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *regex1 = @"\\A[a-z0-9]+([-._][a-z0-9]+)*@([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,4}\\z";
    NSString *regex2 = @"^(?=.{1,64}@.{4,64}$)(?=.{6,100}$).*";
    NSPredicate *test1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate *test2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    return [test1 evaluateWithObject:email] && [test2 evaluateWithObject:email];
}

/*==================================================================================================*/

#pragma mark -
#pragma mark keyboard activities

- (void)resignKeyboard:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]])
    {
        [firstResponder resignFirstResponder];
        [self animateView:0];
        
    }
}

/*==================================================================================================*/

- (void)previousField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]])
    {
        NSUInteger tag = [firstResponder tag];
        NSUInteger previousTag = tag == 1 ? 1 : tag - 1;
        
        [self checkBarButton:previousTag];
        [self animateView:previousTag];
        
        UITextField *previousField = (UITextField *)[self.view viewWithTag:previousTag];
        [previousField becomeFirstResponder];
        
    }
}

/*==================================================================================================*/

- (void)nextField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]])
    {
        NSUInteger tag = [firstResponder tag];
        NSUInteger nextTag = tag == FIELDS_COUNT ? FIELDS_COUNT : tag + 1;
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
        
    }
}

/*==================================================================================================*/


#pragma mark -
#pragma mark Other

- (id)getFirstResponder
{
    NSUInteger index = 0;
    while (index <= FIELDS_COUNT)
    {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder])
        {
            return textField;
        }
        index++;
    }
    return NO;
}

/*==================================================================================================*/

- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_0)
    {
        if (tag == 3)
        {
            if ([UIScreen mainScreen].bounds.size.height > 500)
            {
                rect.origin.y = -105.0f * (tag - 2);
            }
            else
            {
                rect.origin.y = -140.0f * (tag - 2);
            }
        }
        else if(tag==4)
        {
            if ([UIScreen mainScreen].bounds.size.height > 500)
                
                rect.origin.y = -155.0f * (tag - 3);
            else
                
                rect.origin.y = -190.0f * (tag - 3);
        }
        else if ([UIScreen mainScreen].bounds.size.height < 500)
        {
            if (tag == 1)
            {
                rect.origin.y = -45.0f;
            }
            else if (tag == 2)
            {
                rect.origin.y = -75.0f;
                
            }
            else
            {
                rect.origin.y = 0;
                
            }
        }
        else
        {
            rect.origin.y = 0;
            
        }
    }
    else
    {
        if (tag == 3)
        {
            if ([UIScreen mainScreen].bounds.size.height > 500)
            {
                rect.origin.y = -35.0f * (tag - 2);
            }
            else
            {
                rect.origin.y = -120.0f * (tag - 2);
            }
        }
        else if(tag==4)
        {
            if ([UIScreen mainScreen].bounds.size.height > 500)
                
                rect.origin.y = -35.0f * (tag - 3);
            else
                
                rect.origin.y = -130.0f * (tag - 3);
        }
        else if ([UIScreen mainScreen].bounds.size.height < 500)
        {
            if (tag == 1)
            {
                rect.origin.y = -45.0f;
            }
            else if (tag == 2)
            {
                rect.origin.y = -75.0f;
                
            }
            else
            {
                rect.origin.y = 64;
                
            }
        }
        else
        {
            rect.origin.y = 64;
            
        }
        
    }
    
    self.view.frame = rect;
    [UIView commitAnimations];
}

/*==================================================================================================*/

- (void)checkBarButton:(NSUInteger)tag
{
    UIBarButtonItem *previousBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:0];
    UIBarButtonItem *nextBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:1];
    
    [previousBarItem setEnabled:tag == 1 ? NO : YES];
    [nextBarItem setEnabled:tag == FIELDS_COUNT ? NO : YES];
}

/*==================================================================================================*/

#pragma mark - UITextFieldDelegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    [self animateView:tag];
    [self checkBarButton:tag];
    
}

/*==================================================================================================*/

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

/*==================================================================================================*/


@end
