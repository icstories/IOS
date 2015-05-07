//
//  HomeViewController.h
//  ICStories
//
//  Created by Rahul Kalavar on 13/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import <UIKit/UIKit.h>
#import "UploadViewController.h"
#import "CaptureVideoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIButton+WebCache.h"

/*============================================================================================*/

@interface HomeViewController : UIViewController<UITabBarControllerDelegate,UITabBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UploadDelegate,UITextFieldDelegate>
{
    NSURL   *videoUrl;
    UIImagePickerController *pickerController;
    
}


/*============================================================================================*/

@property (weak, nonatomic) IBOutlet UIButton *assignmentButton;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *assignmentDesLabel;
@property (weak, nonatomic) IBOutlet UITextView *imageUrlTextview;
@property (strong, nonatomic) UIImagePickerController *pickerController;
@property (weak, nonatomic) IBOutlet UIControl   *control;
- (IBAction)showFullImage:(id)sender;
- (IBAction)uploadVideo:(id)sender;
- (IBAction)selectVideo:(id)sender;
- (IBAction)recordVideo:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTranslatedName;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *selectVideoButton;

/*============================================================================================*/

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (nonatomic, strong) NSURL   *videoUrl;

/*============================================================================================*/


@end
