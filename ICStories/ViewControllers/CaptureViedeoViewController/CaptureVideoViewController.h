//
//  CaptureVideoViewController.h
//  ICStories
//
//  Created by Rahul Kalavar on 14/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//

/*============================================================================================*/


#import <UIKit/UIKit.h>
#import "CameraEngine.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BaseViewController.h"

/*============================================================================================*/

@interface CaptureVideoViewController : BaseViewController<UIAlertViewDelegate>
{
    BOOL        isItPlayingVideo;
    BOOL        isVideoStarted;
    NSTimer     *timer;
    int         minute;
    int         second;
    
}

/*============================================================================================*/

- (IBAction)closeVideo:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) NSTimer     *timer;

/*============================================================================================*/

- (IBAction)stopVideo:(id)sender;
- (IBAction)playPauseVideo:(id)sender;


/*============================================================================================*/

@end
