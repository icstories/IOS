//
//  WallViewController.m
//  ICStories
//
//  Created by Rahul Kalavar on 13/01/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import "WallViewController.h"

/*============================================================================================*/

@interface WallViewController ()

@end

/*============================================================================================*/

@implementation WallViewController
@synthesize wallInfo;
@synthesize thumbNailURL;
@synthesize videoURL;

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
    
    [activityIndicator startAnimating];
    indicatorMainView.hidden = NO;
    self.loadingActivityIndicator.hidden = YES;
    self.videoTableView.backgroundView = nil;
    self.videoTableView.backgroundColor = [UIColor clearColor];

    self.wallInfo = [[NSMutableArray alloc] init];
    [indicatorMainView setHidden:NO];
    [activityIndicator startAnimating];
    if (self.wallInfo != nil)
    {
        [self.wallInfo removeAllObjects];
        
    }
    

    
//    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
//    refresh.tintColor = [UIColor blackColor];
//    [refresh addTarget:self action:@selector(refresh:)
//      forControlEvents:UIControlEventValueChanged];
//    [self.videoTableView addSubview:refresh];
}

/*============================================================================================*/

-(void)refresh:(UIRefreshControl *)sender
{
    [sender endRefreshing];
    [indicatorMainView setHidden:NO];
    [activityIndicator startAnimating];
    if (self.wallInfo != nil)
    {
        [self.wallInfo removeAllObjects];
        
    }
    [self performSelector:@selector(showWall:) withObject:@"0" afterDelay:0.2];
    [self.videoTableView reloadData];
}

/*============================================================================================*/

-(void)showWall:(NSString *)startNumber
{
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.icstories.com/icstories/webservices/users/user_wall"]];
   // NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://bizmoapps.com/icstories/webservices/users/user_wall"]];

    [theRequest setTimeoutInterval:60];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"wall" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //User id
    NSArray *userIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[[userIds objectAtIndex:0] objectForKey:@"user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"start\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[startNumber dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:body];
    
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (!internetStatus)
    {
        [activityIndicator stopAnimating];
        [indicatorMainView setHidden:YES];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have no internet connection please check" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [activityIndicator stopAnimating];
        [indicatorMainView setHidden:YES];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//        UIAlertView *alet = [[UIAlertView alloc] initWithTitle:nil message:returnString delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alet show];
        NSData *jsonData = [returnString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        if ([[myDictionary objectForKey:@"statusInfo"] isEqualToString:@"success"])
        {
            self.loadingActivityIndicator.hidden = YES;
            
            if (((NSArray*)[myDictionary objectForKey:@"wall_info"]).count != 0)
            {
                [activityIndicator stopAnimating];
                [indicatorMainView setHidden:YES];
                [self.wallInfo addObjectsFromArray:[myDictionary objectForKey:@"wall_info"]];
                self.videoURL = [myDictionary objectForKey:@"video_url"];
                self.thumbNailURL = [myDictionary objectForKey:@"video_thumb_url"];
                self.thumbNailURL = [self.thumbNailURL stringByAppendingString:@"/"];
                [self.videoTableView reloadData];
            }
            else
            {
                [activityIndicator stopAnimating];
                [indicatorMainView setHidden:YES];
            }
        }
    }
}

/*==================================================================================================*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

/*==================================================================================================*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wallInfo.count;
}

/*==================================================================================================*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *cellIdentifire = @"cellIdentifire";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    CGRect rect = ((UILabel *)[cell viewWithTag:104]).frame;
    ((UILabel *)[cell viewWithTag:100]).text = [[self.wallInfo objectAtIndex:indexPath.row] objectForKey:@"video_title"];
    
    self.thumbNailURL = [self.thumbNailURL stringByAppendingString:[[self.wallInfo objectAtIndex:indexPath.row] objectForKey:@"video_thumb"]];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];

    CGSize fontsize = [self text:[[self.wallInfo objectAtIndex:indexPath.row] objectForKey:@"video_description"] sizeWithFont:cellFont constrainedToSize:CGSizeMake(296,9999) withLinebreakmode:NSLineBreakByWordWrapping] ;
//    [[[self.wallInfo objectAtIndex:indexPath.row] objectForKey:@"video_description"] sizeWithFont:cellFont constrainedToSize:CGSizeMake(296,9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    ((UILabel *)[cell viewWithTag:104]).frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, fontsize.height);
    
    ((UILabel *)[cell viewWithTag:104]).text = [[self.wallInfo objectAtIndex:indexPath.row] objectForKey:@"video_description"];
    ((UILabel *)[cell viewWithTag:102]).text = [[self.wallInfo objectAtIndex:indexPath.row] objectForKey:@"assignment_date"];
    ((UILabel *)[cell viewWithTag:103]).text = [[self.wallInfo objectAtIndex:indexPath.row] objectForKey:@"location"];
    [((UIImageView *)[cell viewWithTag:101]) sd_setImageWithURL:[NSURL URLWithString:self.thumbNailURL]];
    self.thumbNailURL = @"http://www.icstories.com/icstories/uploads/video/thumb/";
    //self.thumbNailURL = @"http://bizmoapps.com/icstories/uploads/video/thumb/";
    return cell;

}

/*==================================================================================================*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];

    CGSize fontsize = [self text:[[self.wallInfo objectAtIndex:indexPath.row] objectForKey:@"video_description"] sizeWithFont:cellFont constrainedToSize:CGSizeMake(296,9999) withLinebreakmode:NSLineBreakByWordWrapping] ;
    height = fontsize.height + 272;
    
    return height;
}
/*==================================================================================================*/

-(CGSize)text:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)ConstSize withLinebreakmode :(NSLineBreakMode) linebreakmode
{
    CGSize retsize;
    
    if ([text respondsToSelector:
         @selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = linebreakmode;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary * attributes = @{NSFontAttributeName : font,
                                      NSParagraphStyleAttributeName : paragraphStyle};
        
        retsize = [text boundingRectWithSize:ConstSize
                                     options:NSStringDrawingUsesFontLeading
                   |NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil].size;
        retsize.height =ceilf(retsize.height);
        retsize.width =ceilf(retsize.width);
        
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([text respondsToSelector:
             @selector(sizeWithFont:constrainedToSize:lineBreakMode:)])
        {
            retsize = [text sizeWithFont:font
                       constrainedToSize:ConstSize
                           lineBreakMode:linebreakmode];
        }
        
#pragma clang diagnostic pop
    }
    return retsize;
}
/*==================================================================================================*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
//    self.wallInfo = nil;
//    self.thumbNailURL = nil;
//    self.videoURL = nil;
//    self.videoTableView = nil;
//    self.loadingActivityIndicator = nil;
}

/*==================================================================================================*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [indicatorMainView setHidden:NO];
    [activityIndicator startAnimating];
    if (self.wallInfo != nil)
    {
        [self.wallInfo removeAllObjects];
        
    }
    [self performSelector:@selector(showWall:) withObject:@"0" afterDelay:0.2];
    [self.videoTableView reloadData];
    
    self.navigationController.navigationBar.hidden = YES;
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"VideoUploadSuccesfully"] == YES)
//    {
//
//        [self performSelector:@selector(showWall:) withObject:@"0" afterDelay:0.2];
//        [self.videoTableView reloadData];
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"VideoUploadSuccesfully"];
//    }
}

/*============================================================================================*/

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (self.wallInfo.count-1 == indexPath.row)
    {
        if (indexPath.row != 0)
        {
            self.loadingActivityIndicator.hidden = NO;
        }
        NSString *countInfo = [NSString stringWithFormat:@"%d",self.wallInfo.count];
        [self performSelector:@selector(showWall:) withObject:countInfo afterDelay:0];
    }
}

/*============================================================================================*/

- (IBAction)playVideo:(id)sender
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        UIButton *button = (UIButton *)sender;
        UIView *containtView = [button superview];
        UITableViewCell *buttonCell = (UITableViewCell *)containtView.superview;
        NSIndexPath* pathOfTheCell = [self.videoTableView indexPathForCell:buttonCell];
      //  NSString *videoData = [@"http://bizmoapps.com/icstories/uploads/video/" stringByAppendingString:[[self.wallInfo objectAtIndex:pathOfTheCell.row] objectForKey:@"video_data"]];
        NSString *videoData = [@"http://www.icstories.com/icstories/uploads/video/" stringByAppendingString:[[self.wallInfo objectAtIndex:pathOfTheCell.row] objectForKey:@"video_data"]];
        
        MPMoviePlayerViewController* theMovie =
        [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:videoData]];
        [theMovie.moviePlayer setShouldAutoplay:YES];
        theMovie.moviePlayer.scalingMode = MPMovieScalingModeNone;
        [self presentMoviePlayerViewControllerAnimated:theMovie];
    }
    else
    {
        UIButton *button = (UIButton *)sender;
        UITableViewCell *buttonCell = (UITableViewCell *)button.superview.superview;
        NSIndexPath* pathOfTheCell = [self.videoTableView indexPathForCell:buttonCell];
        
        NSString *videoData = [@"http://www.icstories.com/icstories/uploads/video/" stringByAppendingString:[[self.wallInfo objectAtIndex:pathOfTheCell.row] objectForKey:@"video_data"]];
     //    NSString *videoData = [@"http://bizmoapps.com/icstories/uploads/video/" stringByAppendingString:[[self.wallInfo objectAtIndex:pathOfTheCell.row] objectForKey:@"video_data"]];
        MPMoviePlayerViewController* theMovie =
        [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:videoData]];
        [theMovie.moviePlayer setShouldAutoplay:YES];
        theMovie.moviePlayer.scalingMode = MPMovieScalingModeNone;
        [self presentMoviePlayerViewControllerAnimated:theMovie];

    }
}

/*============================================================================================*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
       // NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://bizmoapps.com/icstories/webservices/users/delete"]];
         NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.icstories.com/icstories/webservices/users/delete"]];
        [theRequest setTimeoutInterval:60];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"delete" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"video_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[[self.wallInfo objectAtIndex:selectedVideo] objectForKey:@"video_id"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody:body];
        
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        if (!internetStatus)
        {
            [activityIndicator stopAnimating];
            [indicatorMainView setHidden:YES];
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have no internet connection please check" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
            NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            NSData *jsonData = [returnString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *error = nil;
            NSDictionary *myDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if ([[myDictionary objectForKey:@"statusInfo"] isEqualToString:@"success"])
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Video Deleted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [indicatorMainView setHidden:NO];
                [activityIndicator startAnimating];
                if (self.wallInfo != nil)
                {
                    [self.wallInfo removeAllObjects];
                    
                }
                [self performSelector:@selector(showWall:) withObject:@"0" afterDelay:0.2];
                [self.videoTableView reloadData];
            }
        }
    }
}

/*============================================================================================*/


- (IBAction)deleteVideo:(id)sender
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        UIButton *button = (UIButton *)sender;
        UIView *containtView = button.superview;
        UITableViewCell *buttonCell =   (UITableViewCell *)containtView.superview;
        NSIndexPath* pathOfTheCell = [self.videoTableView indexPathForCell:buttonCell];
        selectedVideo = pathOfTheCell.row;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure, you want to delete?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
    }
    else
    {
        UIButton *button = (UIButton *)sender;
        UITableViewCell *buttonCell = (UITableViewCell *)button.superview.superview;
        NSIndexPath* pathOfTheCell = [self.videoTableView indexPathForCell:buttonCell];
        
        selectedVideo = pathOfTheCell.row;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure, you want to delete?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
    }

}

/*============================================================================================*/

@end
