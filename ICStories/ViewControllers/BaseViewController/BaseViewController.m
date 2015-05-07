//
//  BaseViewController.m
//  CombatShot
//
//  Created by Rahul Kalavar on 01/10/13.
//  Copyright (c) 2013 Eeshana. All rights reserved.
//

/*============================================================================================*/

#import "BaseViewController.h"

/*============================================================================================*/

@interface BaseViewController ()

@end

/*============================================================================================*/

@implementation BaseViewController

/*==========================================================================================*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(self.view.frame.size.width/2-22,self.view.frame.size.height/2-55, 40.0, 40.0);
    activityIndicator.color = [UIColor whiteColor];
    [activityIndicator stopAnimating];
    
    UIView *localView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    localView.backgroundColor = [UIColor clearColor];
    indicatorMainView = localView;
    [localView addSubview:activityIndicator];
    [self.view addSubview:localView];
    indicatorMainView.hidden = YES;
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-35, self.view.frame.size.height/2 - 20, 80, 20)];
    loadingLabel.text = @"Loading...";
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    [localView addSubview:loadingLabel];
    
}

/*==========================================================================================*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*============================================================================================*/

@end
