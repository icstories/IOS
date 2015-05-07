//
//  UploadViewController.h
//  ICStories
//
//  Created by demo on 13/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import <UIKit/UIKit.h>
#import "UIImage+Utilities.h"

#import "Base64.h"
#import <CoreLocation/CoreLocation.h>

#import "BWStatusBarOverlay.h"
#import "ICStoriesAppDelegate.h"
#import "Reachability.h"

@protocol UploadDelegate;

/*============================================================================================*/

@interface UploadViewController : UIViewController<CLLocationManagerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSURL *url;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    UIToolbar *keyboardToolbar;
    NSMutableData   *receivedData;
}

/*============================================================================================*/

@property (weak, nonatomic) id<UploadDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIButton *yesNoButton;
@property (nonatomic, strong)  NSURL *url;
@property(nonatomic, strong) UIToolbar *keyboardToolbar;
@property (nonatomic, strong) NSMutableData   *receivedData;
- (IBAction)setYesNoValue:(id)sender;

/*============================================================================================*/

- (IBAction)uploadVideo:(id)sender;

/*============================================================================================*/

@end

@protocol  UploadDelegate <NSObject>

-(void)statusSuccess;
-(void)statusFail;
-(void)uploadingStart;
@end
