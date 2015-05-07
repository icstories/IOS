//
//  HomeViewController.m
//  ICStories
//
//  Created by Rahul Kalavar on 13/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import "HomeViewController.h"

/*============================================================================================*/

@interface HomeViewController ()

@end



/*============================================================================================*/

@implementation HomeViewController

@synthesize videoUrl;
@synthesize pickerController;

/*============================================================================================*/

#pragma mark -
#pragma mark - Set image to tab bar
#pragma mark -

/*============================================================================================*/

- (void)setTabBarImages
{
    self.tabBarController.delegate = self;
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        tabBar.frame = CGRectMake(1, tabBar.frame.origin.y+6, tabBar.frame.size.width,  tabBar.frame.size.height);
        
        tabBarItem1.image =[[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem1.selectedImage =[[UIImage imageNamed:@"selected_home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        tabBarItem2.image =[[UIImage imageNamed:@"wall.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem2.selectedImage =[[UIImage imageNamed:@"selected_wall.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        tabBarItem3.image =[[UIImage imageNamed:@"setting_7.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem3.selectedImage =[[UIImage imageNamed:@"selected_setting_7.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
    else
    {
        [[tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"selected_home"] withFinishedUnselectedImage:[UIImage imageNamed:@"home"]];
        
        [[tabBar.items objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:@"selected_wall"] withFinishedUnselectedImage:[UIImage imageNamed:@"wall"]];
        
        [[tabBar.items objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:@"selected_setting"] withFinishedUnselectedImage:[UIImage imageNamed:@"setting"]];

    }
    
}

/*============================================================================================*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1)
    {
        if (([UIScreen mainScreen].bounds.size.height > 500))
        {
            ([(UIView *) self.view viewWithTag:789]).frame = CGRectMake(16, 93, 288, 230);
            
            self.recordButton.frame = CGRectMake(self.recordButton.frame.origin.x,344, self.recordButton.frame.size.width, self.recordButton.frame.size.height);
            
            self.selectVideoButton.frame = CGRectMake(self.selectVideoButton.frame.origin.x,399, self.selectVideoButton.frame.size.width, self.selectVideoButton.frame.size.height);
            
            self.uploadButton.frame = CGRectMake(self.uploadButton.frame.origin.x,455, self.uploadButton.frame.size.width, self.uploadButton.frame.size.height);
        }
        else
        {
            ([(UIView *) self.view viewWithTag:789]).frame = CGRectMake(16, 90, 288, 190);
            
            self.recordButton.frame = CGRectMake(self.recordButton.frame.origin.x,290, self.recordButton.frame.size.width, self.recordButton.frame.size.height);
            
            self.selectVideoButton.frame = CGRectMake(self.selectVideoButton.frame.origin.x,338, self.selectVideoButton.frame.size.width, self.selectVideoButton.frame.size.height);
            
            self.uploadButton.frame = CGRectMake(self.uploadButton.frame.origin.x,387, self.uploadButton.frame.size.width, self.uploadButton.frame.size.height);

        }
        
    }
    else
    {
        if (([UIScreen mainScreen].bounds.size.height > 500))
        {
        
        }
    
    }
    
   [self setTabBarImages];
    
    if ([UIScreen mainScreen].bounds.size.height > 500)
    {
        ((UIImageView *)[self.view viewWithTag:231]).image = [UIImage imageNamed:@"login_bg5"];
    }
    else
        ((UIImageView *)[self.view viewWithTag:231]).image = [UIImage imageNamed:@"login_bg"];

    self.control.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BlackBackground.png"]];
    
    [self.control addTarget:self action:@selector(backgroundTapped) forControlEvents:UIControlEventAllEvents];
    
    
    ((UIView *)[self.view viewWithTag:32]).hidden = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"UPLOAD_USERINTERACTION"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"IsUploadingStarted"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissImagePicker:) name:@"AssignmentAdded" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNotification) name:@"New_Assignment" object:nil];
    
    
    NSArray *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"assignment_info"];
    if (info != nil || info.count != 0)
    {
        NSString *firstComma = @"\"";
        NSString *secondComma = @"\"";
        self.assignmentDesLabel.text = [firstComma stringByAppendingString:[[[info objectAtIndex:0] objectForKey:@"assignment_name"] stringByAppendingString:secondComma]];
        self.date.text = [[info objectAtIndex:0] objectForKey:@"assignment_date"];
        NSString *imageUrl = [@"http://www.icstories.com/icstories/uploads/assignments/" stringByAppendingString:[[info objectAtIndex:0] objectForKey:@"assignment_file"]];
      //  NSString *imageUrl = [@"http://bizmoapps.com/icstories/uploads/assignments/" stringByAppendingString:[[info objectAtIndex:0] objectForKey:@"assignment_file"]];
        self.lblTranslatedName.text=[[info objectAtIndex:0]objectForKey:@"translated_name"];
        NSLog(@"Translated Name=%@",[[info objectAtIndex:0]objectForKey:@"translated_name"]);

        [((UIButton *)[self.view viewWithTag:31]) sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
        
        [self.assignmentButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
        
        self.imageUrlTextview.text = [[info objectAtIndex:0] objectForKey:@"assignment_url"];

        if ([[[info objectAtIndex:0] objectForKey:@"assignment_file"] isEqualToString:@""] && [[[info objectAtIndex:0] objectForKey:@"assignment_url"] isEqualToString:@""])
        {
            self.assignmentButton.hidden = YES;
            self.imageUrlTextview.hidden = YES;
            
            if ([UIScreen mainScreen].bounds.size.height > 500)
            {
                self.assignmentDesLabel.frame = CGRectMake(15, 78, 257, 73);
            }
            else
            {
                self.assignmentDesLabel.frame = CGRectMake(15, 63, 257, 59);
            }
        }
        else
            if([[[info objectAtIndex:0] objectForKey:@"assignment_file"] isEqualToString:@""])
            {
                self.assignmentButton.hidden = YES;
                self.imageUrlTextview.hidden = NO;
                
                if ([UIScreen mainScreen].bounds.size.height > 500)
                {
                    self.assignmentDesLabel.frame = CGRectMake(15, 78, 257, 73);
                    self.imageUrlTextview.frame = CGRectMake(15, 170, 257, 39);
                }
                else
                {
                    self.assignmentDesLabel.frame = CGRectMake(15, 63, 257, 59);
                    self.imageUrlTextview.frame = CGRectMake(15, 140, 257, 35);
                }
            }
            else
                if ([[[info objectAtIndex:0] objectForKey:@"assignment_url"] isEqualToString:@""])
                {
                    self.assignmentButton.hidden = NO;
                    self.imageUrlTextview.hidden = YES;
                    
                    if ([UIScreen mainScreen].bounds.size.height > 500)
                    {
                        self.assignmentButton.frame = CGRectMake(15,100, 60, 60);
                        self.assignmentDesLabel.frame = CGRectMake(87, 100, 185, 60);
                    }
                    else
                    {
                        self.assignmentButton.frame = CGRectMake(15, 83, 60, 60);
                        self.assignmentDesLabel.frame = CGRectMake(87, 83, 185, 59);
                    }
                }
                else
                {
                    self.assignmentButton.hidden = NO;
                    self.imageUrlTextview.hidden = NO;
                    if ([UIScreen mainScreen].bounds.size.height > 500)
                    {
                        self.assignmentButton.frame = CGRectMake(15,78, 60, 60);
                        self.assignmentDesLabel.frame = CGRectMake(87, 78, 185, 60);
                        self.imageUrlTextview.frame = CGRectMake(15, 170, 257, 39);
                    }
                    else
                    {
                        self.assignmentButton.frame = CGRectMake(15, 63, 60, 60);
                        self.assignmentDesLabel.frame = CGRectMake(87, 63, 185, 59);
                        self.imageUrlTextview.frame = CGRectMake(15, 140, 257, 39);
                    }
                    
                }
        
    }
    else
    {
        if ([UIScreen mainScreen].bounds.size.height > 500)
        {
            self.assignmentDesLabel.frame = CGRectMake(15, 78, 257, 73);
        }
        else
        {
            self.assignmentDesLabel.frame = CGRectMake(15, 63, 257, 59);
        }
    }
  
}

/*============================================================================================*/

-(void)dismissImagePicker:(id)sender
{
    [self.pickerController dismissViewControllerAnimated:YES completion:NULL];
    //[self performSelector:@selector(newNotification) withObject:nil afterDelay:0];
}

/*============================================================================================*/

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}

/*============================================================================================*/

-(void)newNotification
{
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.icstories.com/icstories/webservices/users/get_assignment"]]; //Live server

    [theRequest setTimeoutInterval:60];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"assignment" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    UIAlertView *alet = [[UIAlertView alloc] initWithTitle:nil message:returnString delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//    [alet show];
    NSData *jsonData = [returnString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (((NSArray*)[myDictionary objectForKey:@"assignment_info"]).count != 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[myDictionary objectForKey:@"assignment_info"] forKey:@"assignment_info"];
    }
    
    NSArray *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"assignment_info"];
   
    if (info != nil || info.count != 0)
    {
        NSString *firstComma = @"\"";
        NSString *secondComma = @"\"";
        self.assignmentDesLabel.text = [firstComma stringByAppendingString:[[[info objectAtIndex:0] objectForKey:@"assignment_name"] stringByAppendingString:secondComma]];
        self.date.text = [[info objectAtIndex:0] objectForKey:@"assignment_date"];
        NSString *imageUrl = [@"http://www.icstories.com/icstories/uploads/assignments/" stringByAppendingString:[[info objectAtIndex:0] objectForKey:@"assignment_file"]];
      // NSString *imageUrl = [@"http://bizmoapps.com/icstories/webservices/users/upload_video" stringByAppendingString:[[info objectAtIndex:0] objectForKey:@"assignment_file"]];
        [((UIButton *)[self.view viewWithTag:31]) sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
        
        [self.assignmentButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
        
        self.imageUrlTextview.text = [[info objectAtIndex:0] objectForKey:@"assignment_url"];
        
        if ([[[info objectAtIndex:0] objectForKey:@"assignment_file"] isEqualToString:@""] && [[[info objectAtIndex:0] objectForKey:@"assignment_url"] isEqualToString:@""])
        {
            self.assignmentButton.hidden = YES;
            self.imageUrlTextview.hidden = YES;

            if ([UIScreen mainScreen].bounds.size.height > 500)
            {
                self.assignmentDesLabel.frame = CGRectMake(15, 78, 257, 73);
            }
            else
            {
                self.assignmentDesLabel.frame = CGRectMake(15, 63, 257, 59);
            }
        }
        else
        if([[[info objectAtIndex:0] objectForKey:@"assignment_file"] isEqualToString:@""])
        {
            self.assignmentButton.hidden = YES;
            self.imageUrlTextview.hidden = NO;

            if ([UIScreen mainScreen].bounds.size.height > 500)
            {
                self.assignmentDesLabel.frame = CGRectMake(15, 78, 257, 73);
                self.imageUrlTextview.frame = CGRectMake(15, 170, 257, 39);
            }
            else
            {
               self.assignmentDesLabel.frame = CGRectMake(15, 63, 257, 59);
               self.imageUrlTextview.frame = CGRectMake(15, 135, 257, 35);
            }
        }
        else
        if ([[[info objectAtIndex:0] objectForKey:@"assignment_url"] isEqualToString:@""])
        {
            self.assignmentButton.hidden = NO;
            self.imageUrlTextview.hidden = YES;
            
            if ([UIScreen mainScreen].bounds.size.height > 500)
            {
                self.assignmentButton.frame = CGRectMake(15,100, 60, 60);
                self.assignmentDesLabel.frame = CGRectMake(87, 100, 185, 60);
            }
            else
            {
                self.assignmentButton.frame = CGRectMake(15, 83, 60, 60);
                self.assignmentDesLabel.frame = CGRectMake(87, 83, 185, 59);
            }
        }
        else
        {
            self.assignmentButton.hidden = NO;
            self.imageUrlTextview.hidden = NO;
            if ([UIScreen mainScreen].bounds.size.height > 500)
            {
                self.assignmentButton.frame = CGRectMake(15,78, 60, 60);
                self.assignmentDesLabel.frame = CGRectMake(87, 78, 185, 60);
                self.imageUrlTextview.frame = CGRectMake(15, 170, 257, 39);
            }
            else
            {
                self.assignmentButton.frame = CGRectMake(15, 63, 60, 60);
                self.assignmentDesLabel.frame = CGRectMake(87, 63, 185, 59);
                self.imageUrlTextview.frame = CGRectMake(15, 135, 257, 39);
            }
            
        }
        
    }
    
    self.tabBarController.selectedIndex = 0;
}


/*============================================================================================*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
//    self.date = nil;
//    self.assignmentDesLabel = nil;
//    self.pickerController = nil;
}

/*============================================================================================*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

/*============================================================================================*/

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
}
/*============================================================================================*/

-(void)backgroundTapped
{
   // ((UIView *)[self.view viewWithTag:32]).frame = [UIScreen mainScreen].bounds;
    [UIView beginAnimations:@"Hide" context:nil];
    [UIView setAnimationDuration:0.5];
    ((UIView *)[self.view viewWithTag:32]).frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height);
    [UIView commitAnimations];
  //  ((UIView *)[self.view viewWithTag:32]).hidden = YES;

}
/*============================================================================================*/

- (IBAction)showFullImage:(id)sender
{
    ((UIView *)[self.view viewWithTag:32]).hidden = NO;
    ((UIView *)[self.view viewWithTag:32]).frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height);

    [UIView beginAnimations:@"Show" context:nil];
    [UIView setAnimationDuration:0.5];
    ((UIView *)[self.view viewWithTag:32]).frame = [UIScreen mainScreen].bounds;
    [UIView commitAnimations];
}

/*============================================================================================*/

- (IBAction)uploadVideo:(id)sender
{
    if (([[NSUserDefaults standardUserDefaults] integerForKey:@"UPLOAD_USERINTERACTION"] == 1))
    {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"IsUploadingStarted"] == 1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Uploading is in progress" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            UploadViewController *uploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadViewController"];
            uploadVC.url = self.videoUrl;
            uploadVC.delegate = self;
            [self.navigationController pushViewController:uploadVC animated:YES];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select or record video" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

/*============================================================================================*/

-(void)uploadingStart;
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"IsUploadingStarted"];
}

/*============================================================================================*/

-(void)statusSuccess
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"UPLOAD_USERINTERACTION"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"data"];


    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Video uploaded successfully!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"VideoUploadSuccesfully"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"IsUploadingStarted"];

}

/*============================================================================================*/

-(void)statusFail
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Network fail" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"UPLOAD_USERINTERACTION"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"data"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"IsUploadingStarted"];

}

/*============================================================================================*/

- (IBAction)selectVideo:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"IsUploadingStarted"] == 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Uploading is in progress" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        self.pickerController = [[UIImagePickerController alloc] init];
        self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.pickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        self.pickerController.allowsEditing = YES;
        self.pickerController.delegate = self;
        [self presentViewController:self.pickerController animated:YES completion:NULL];
    }

}

/*============================================================================================*/

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"UPLOAD_USERINTERACTION"];
    
    
    NSURL *pathUrl = (NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
    self.videoUrl = pathUrl;
    AVAsset *asset = [AVAsset assetWithURL:pathUrl];
    CMTime thumbnailTime = [asset duration];
    thumbnailTime.value = 0;

    
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:NULL];
    NSData* pictureData = UIImagePNGRepresentation([UIImage imageWithCGImage:imageRef]);
    [[NSUserDefaults standardUserDefaults] setObject:pictureData forKey:@"ImageData"];
    CGImageRelease(imageRef);
    
    
    NSData *videoData = [NSData dataWithContentsOfURL:pathUrl];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/vid1.mov"];
    
    [videoData writeToFile:tempPath atomically:NO];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

/*============================================================================================*/

- (IBAction)recordVideo:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"IsUploadingStarted"] == 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Uploading is in progress" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Resolution"] == nil)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select resolution from settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            CaptureVideoViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CaptureVideoViewController"];
            [self presentViewController:cvc animated:YES completion:NULL];
        }

    }
}


/*============================================================================================*/

@end
