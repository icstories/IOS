//
//  CaptureVideoViewController.m
//  ICStories
//
//  Created by Rahul Kalavar on 14/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import "CaptureVideoViewController.h"

/*============================================================================================*/

@interface CaptureVideoViewController ()

@end

/*============================================================================================*/

@implementation CaptureVideoViewController
@synthesize timer;

/*============================================================================================*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeVideo:) name:@"AssignmentAdded" object:nil];
    isVideoStarted = YES;
    
    [activityIndicator startAnimating];
    indicatorMainView.hidden = NO;
    
    [self performSelector:@selector(showCamera) withObject:nil afterDelay:0.2];
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
/*============================================================================================*/

-(void)showCamera
{
    [[CameraEngine engine] startup:[[NSUserDefaults standardUserDefaults] objectForKey:@"Resolution"]];
    [self startPreview];
    second = 0;
    minute = 0;
    self.stopButton.enabled = NO;
    self.timeLabel.text = @"00 : 00";
    [activityIndicator stopAnimating];
    indicatorMainView.hidden = YES;
}

- (void) startPreview
{
    AVCaptureVideoPreviewLayer* preview = [[CameraEngine engine] getPreviewLayer];
    [preview removeFromSuperlayer];
    CGRect layerRect = [[[self view] layer] bounds];
    [preview setBounds:layerRect];
    [preview setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                     CGRectGetMidY(layerRect))];
    
    [self.cameraView.layer addSublayer:preview];
}

/*============================================================================================*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //    self.timeLabel = nil;
    //    self.timer = nil;
    //    self.stopButton = nil;
    //    self.playPauseButton = nil;
    //    self.cameraView = nil;
}

/*============================================================================================*/

- (IBAction)stopVideo:(id)sender
{
    [[CameraEngine engine] stopCapture];
    
    [self.timer invalidate];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

/*============================================================================================*/

- (IBAction)playPauseVideo:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (isVideoStarted)
    {
        self.stopButton.enabled = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTimeToLabel) userInfo:nil repeats:YES];
        [[CameraEngine engine] startCapture];
        isVideoStarted = NO;
        isItPlayingVideo = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"PauseButton"] forState:UIControlStateNormal];
    }
    else
    {
        if (isItPlayingVideo)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"RecordButton"] forState:UIControlStateNormal];
            [self.timer invalidate];
            [[CameraEngine engine] pauseCapture];
            isItPlayingVideo = NO;
        }
        else
        {
            [button setBackgroundImage:[UIImage imageNamed:@"PauseButton"] forState:UIControlStateNormal];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTimeToLabel) userInfo:nil repeats:YES];
            
            [[CameraEngine engine] resumeCapture];
            isItPlayingVideo = YES;
        }
    }
}

/*============================================================================================*/

-(void)dealloc
{
    [[CameraEngine engine] shutdown];
}

/*============================================================================================*/

-(void)setTimeToLabel
{
    NSString *secondString;
    second = second + 1;
    if (second <= 9)
        secondString = [NSString stringWithFormat:@"0%d",second];
    else
        secondString = [NSString stringWithFormat:@"%d",second];
    if (second == 59 || second > 59)
    {
        second = 0;
        minute = minute + 1;
    }
    
    if (minute == 5)
    {
        secondString = [NSString stringWithFormat:@"%d",0];
        [self.timer invalidate];
        [[CameraEngine engine] stopCapture];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You can not record video more that 5 minutes." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"0%d : %@",minute,secondString];
    
}

/*============================================================================================*/

- (IBAction)closeVideo:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

/*============================================================================================*/

@end
