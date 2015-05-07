//
//  WallViewController.h
//  ICStories
//
//  Created by Rahul Kalavar on 13/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BaseViewController.h"
#import "Reachability.h"

/*============================================================================================*/

@interface WallViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray          *wallInfo;
    NSString                *thumbNailURL;
    NSString                *videoURL;
    int                     selectedVideo;
}

/*============================================================================================*/

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView    *loadingActivityIndicator;
@property (weak, nonatomic) IBOutlet UITableView                *videoTableView;
@property (strong, nonatomic) NSMutableArray                    *wallInfo;
@property (strong, nonatomic) NSString                          *thumbNailURL;
@property (strong, nonatomic) NSString                          *videoURL;

/*============================================================================================*/

- (IBAction)playVideo:(id)sender;
- (IBAction)deleteVideo:(id)sender;

/*============================================================================================*/

@end
