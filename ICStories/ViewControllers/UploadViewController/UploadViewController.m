//
//  UploadViewController.m
//  ICStories
//
//  Created by demo on 13/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import "UploadViewController.h"
#import <QuartzCore/QuartzCore.h>

/*============================================================================================*/

@interface UploadViewController ()

@end

/*============================================================================================*/

@implementation UploadViewController

/*============================================================================================*/

@synthesize url;
@synthesize delegate;
@synthesize keyboardToolbar;
@synthesize receivedData;

/*============================================================================================*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.receivedData = [[NSMutableData alloc] init];

    if (self.keyboardToolbar == nil)
    {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
        self.keyboardToolbar.barStyle=UIBarStyleBlack;
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
        
        self.titleTextField.inputAccessoryView = self.keyboardToolbar;
        self.descriptionTextView.inputAccessoryView = self.keyboardToolbar;
        self.locationTextField.inputAccessoryView = self.keyboardToolbar;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backButtonClicked:) name:@"AssignmentAdded" object:nil];

    self.scrollView.contentSize = CGSizeMake(320, 560);
    self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, 320, 480);

    if ([UIScreen mainScreen].bounds.size.height > 500)
    {
        self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, 320, 504);
        self.scrollView.contentSize = CGSizeMake(320, 500);
    }
    
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NavAndTabbarBackgroung"]];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        
    }else
    {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    geocoder = [[CLGeocoder alloc] init];

    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Navigationbar"] forBarMetrics:UIBarMetricsDefault];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.navigationController.navigationBar.translucent = NO;
    }
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton setFrame:CGRectMake(0.0f, 0.0f, 50.0f, 28.0f)];
    [cancelButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = doneBarButton;

    self.titleTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    self.locationTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10,0,0);
    
    [self.locationTextField setValue:[UIColor darkGrayColor]
                 forKeyPath:@"_placeholderLabel.textColor"];
    [self.titleTextField setValue:[UIColor darkGrayColor]
                          forKeyPath:@"_placeholderLabel.textColor"];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    
    self.descriptionTextView.font = font;
    self.locationTextField.font =font;
    self.titleTextField.font = font;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.locationTextField.text.length==0)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    
}


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    CLLocation *currentLocation = newLocation;
//    if (currentLocation != nil)
//    {
//        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            dispatch_async( dispatch_get_main_queue(), ^{
//                
//                NSDictionary* json = nil;
//
//                NSString *longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//                NSString *lattitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
//                
//                NSString *newUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true",lattitude,longitude];
//                NSURL *googleRequestURL=[NSURL URLWithString:[newUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
//                NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
//                NSError* error;
//                if (data != nil)
//                {
//                    json = [NSJSONSerialization
//                            JSONObjectWithData:data
//                            options:kNilOptions
//                            error:&error];
//                }
//                
//                NSArray* places = [json objectForKey:@"results"];
//                self.locationTextField.text = [[[[places objectAtIndex:0] objectForKey:@"address_components"] objectAtIndex:4] objectForKey:@"long_name"];
//
//            });
//        });
//    }
//}
/*============================================================================================*/


#pragma mark- core location delegates
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // NSLog(@"didUpdateLocations");
    
    CLLocation *currentLocation = [locations objectAtIndex:0];
  
    if (currentLocation != nil)
    {
        [locationManager stopUpdatingLocation];
        
        if (currentLocation.coordinate.latitude !=0.0 && currentLocation.coordinate.longitude !=0.0)
        {
            
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    dispatch_async( dispatch_get_main_queue(), ^{
                        
                        if (self.locationTextField.text.length==0)
                        {
                            NSDictionary* json = nil;
                            
                            NSString *longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
                            NSString *lattitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
                            
                            NSString *newUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true",lattitude,longitude];
                            NSURL *googleRequestURL=[NSURL URLWithString:[newUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
                            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
                            NSError* error;
                            if (data != nil)
                            {
                                json = [NSJSONSerialization
                                        JSONObjectWithData:data
                                        options:kNilOptions
                                        error:&error];
                            }
                            
                            NSArray* places = [json objectForKey:@"results"];
                            self.locationTextField.text = [[[[places objectAtIndex:0] objectForKey:@"address_components"] objectAtIndex:4] objectForKey:@"long_name"];
                        
                        }
                    });
                });
            }

    }
}
/*============================================================================================*/

-(void)dealloc
{
    [locationManager stopUpdatingLocation];
}

/*============================================================================================*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

/*============================================================================================*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

/*============================================================================================*/
#define IMAGE_WIDTH 600.0f
#define IMAGE_HEIGHT 600.0f

- (IBAction)uploadVideo:(id)sender
{
    ICStoriesAppDelegate *delegate1 = (ICStoriesAppDelegate *)[[UIApplication sharedApplication] delegate];

    if ([self.titleTextField.text isEqualToString:@""] || [self.descriptionTextView.text isEqualToString:@"Add Description"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please fill required fields" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
    else
    if (self.titleTextField.text.length >= 30)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title limit is 30" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    if (self.descriptionTextView.text.length >= 100)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Description limit is 30" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullpath = [documentsDirectory stringByAppendingPathComponent:@"vid1.mov"];
        NSURL *vedioURL = [NSURL fileURLWithPath:fullpath];
        
        NSData *videoData = [NSData dataWithContentsOfURL:vedioURL];
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ImageData"];
        
        UIImage *imageWithData = [UIImage imageWithData:imageData];
        
        CGSize newSize = CGSizeMake(imageWithData.size.width, imageWithData.size.height);
        UIGraphicsBeginImageContext(newSize);
        [imageWithData drawInRect:CGRectMake(0,0,500,500)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        imageWithData = newImage;

        CGRect clippedRect  = CGRectMake(self.view.frame.origin.x+51, self.view.frame.origin.y,287,169);
        CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], clippedRect);
        UIImage *newImage1   = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        

        NSData *uploadImageData = UIImageJPEGRepresentation(newImage1,1);
        self.descriptionTextView.text = [self.descriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        // VideoURL
        NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.icstories.com/icstories/webservices/users/upload_video"]];
        //Live server http://bizmoapps.com/icstories/webservices/users/upload_video
        
        //Bizmoapp Server http://bizmoapps.com/icstories/webservices/users/upload_video
        [theRequest setTimeoutInterval:120];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"video" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"video_title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[self.titleTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSArray *userIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[[userIds objectAtIndex:0] objectForKey:@"user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"video_description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[self.descriptionTextView.text dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"assignment_flag\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[self.yesNoButton.titleLabel.text dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([self.yesNoButton.titleLabel.text isEqualToString:@"YES"])
        {
            NSArray *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"assignment_info"];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"assignment_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[[info objectAtIndex:0] objectForKey:@"assignment_id"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"assignment_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"location\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[self.locationTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"input_from_dev\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"IOS" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"device_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[delegate1.loggedInDeviceToken dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data;name= \"video\"; filename=\"video1.mov\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:videoData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name= \"video_thumb\"; filename=\"thumb.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:uploadImageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [BWStatusBarOverlay setAnimation:BWStatusBarOverlayAnimationTypeFade];
        [BWStatusBarOverlay showWithMessage:@"Uploading....." loading:YES animated:YES];
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody:body];
        
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        if (!internetStatus)
        {
            [BWStatusBarOverlay showErrorWithMessage:@"Uploding failed" duration:2 animated:YES];

            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have no internet connection please check" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
            [theConnection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                     forMode:NSDefaultRunLoopMode];
            [theConnection start];
            [self.delegate uploadingStart];
            
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [BWStatusBarOverlay dismissAnimated:YES];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    float progress = [[NSNumber numberWithInteger:totalBytesWritten] floatValue];
    float total = [[NSNumber numberWithInteger: totalBytesExpectedToWrite] floatValue];
    [BWStatusBarOverlay setProgress:progress/total animated:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    [self.delegate statusFail];
    [BWStatusBarOverlay showErrorWithMessage:@"Uploding failed" duration:2 animated:YES];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *returnString = [[NSString alloc] initWithData:self.receivedData encoding:NSASCIIStringEncoding];
    NSData *jsonData = [returnString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if ([[myDictionary objectForKey:@"statusInfo"] isEqualToString:@"fail"])
    {
        [self.delegate statusFail];

        [BWStatusBarOverlay showErrorWithMessage:@"Uploding failed" duration:2 animated:YES];
    }
    else
    {
        [self.delegate statusSuccess];
        [BWStatusBarOverlay showSuccessWithMessage:@"Success" duration:2 animated:YES];
    }

}

/*============================================================================================*/

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Add Description"])
    {
        textView.text = @"";
    }
    
    NSUInteger tag = [textView tag];
    [self animateView:tag];
    [self checkBarButton:tag];
}

/*============================================================================================*/

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    textView.textColor = [UIColor blackColor];

    return YES;
}

/*============================================================================================*/

- (void)textViewDidEndEditing:(UITextView *)textView;
{
    self.descriptionTextView.text = [self.descriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([self.titleTextField isFirstResponder])
    {
        CGRect rect = self.view.frame;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        rect.origin.y = 0;
        self.view.frame = rect;
        [UIView commitAnimations];
    }
    if ([textView.text length] == 0)
    {
        self.descriptionTextView.textColor = [UIColor darkGrayColor];
        textView.text = @"Add Description";
    }
    NSUInteger tag = [textView tag];
    [self animateView:tag];
    [self checkBarButton:tag];
}

/*============================================================================================*/

- (IBAction)setYesNoValue:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"YES"])
    {
        [button setTitle:@"NO" forState:UIControlStateNormal];
    }
    else
    {
        [button setTitle:@"YES" forState:UIControlStateNormal];
    }
}

/*============================================================================================*/

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    [self animateView:tag];
    [self checkBarButton:tag];
}

/*============================================================================================*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.titleTextField)
    {
        [textField resignFirstResponder];
        [self.descriptionTextView becomeFirstResponder];
    }
    else if (textField == self.locationTextField)
    {
        [textField resignFirstResponder];
        
        CGRect rect = self.view.frame;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        rect.origin.y = 0;
        self.view.frame = rect;
        [UIView commitAnimations];
    }
    return YES;
}

/*============================================================================================*/


-(void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    else if([firstResponder isKindOfClass:[UITextView class]])
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
    else if([firstResponder isKindOfClass:[UITextView class]])
    {
        [self checkBarButton:1];
        [self animateView:1];
        UITextField *nextField = (UITextField *)[self.view viewWithTag:1];
        [nextField becomeFirstResponder];
        
    }
}

/*==================================================================================================*/

- (void)nextField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]])
    {
        NSUInteger tag = [firstResponder tag];
        NSUInteger nextTag = tag == 3 ? 3 : tag + 1;
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
        
    }
    else if([firstResponder isKindOfClass:[UITextView class]])
    {
        [self checkBarButton:3];
        [self animateView:3];
        UITextField *nextField = (UITextField *)[self.view viewWithTag:3];
        [nextField becomeFirstResponder];

    }
}

/*==================================================================================================*/


#pragma mark -
#pragma mark Other

- (id)getFirstResponder
{
    NSUInteger index = 0;
    while (index <= 3)
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
    CGRect rect = [UIScreen mainScreen].bounds;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag == 3)
    {
        if ([UIScreen mainScreen].bounds.size.height > 500)
        {
            rect.origin.y = -115.0f * (tag - 2);
        }
        else
        {
            rect.origin.y = -160.0f * (tag - 2);
        }
    }
    if (tag == 2)
    {
        rect.origin.y = -80;
    }
    else
    if ([UIScreen mainScreen].bounds.size.height < 500)
    {
        if (tag == 1)
        {
            //First textfield
            rect.origin.y = -45.0f;
        }
        else if (tag == 2)
        {
            //Second text field
            rect.origin.y = -75.0f;
        }
        else if (tag == 3)
        {
            //Second text field
            rect.origin.y = -165.0f;
        }
        else
        {
            if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
                rect.origin.y = 64;
            else
                rect.origin.y = 0;

            self.scrollView.contentOffset = CGPointMake(0, 80);
        }
    }
    else if(tag == 0)
    {
        if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
        {
            rect.origin.y = 64;

        }
        else
            
        rect.origin.y = 0;
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
    [nextBarItem setEnabled:tag == 3 ? NO : YES];
}


/*==================================================================================================*/

@end
