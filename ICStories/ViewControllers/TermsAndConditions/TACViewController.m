//
//  TACViewController.m
//  ICStories
//
//  Created by Rahul Kalavar on 06/05/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//

#import "TACViewController.h"

@interface TACViewController ()

@end

@implementation TACViewController

/*============================================================================================*/

@synthesize isThatTaC;

/*============================================================================================*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ((UILabel *)[self.view viewWithTag:456]).text = @"";
    
    
    if(isThatTaC)
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.icstories.com/icstories/home/termsofuse"]];
        ((UILabel *)[self.view viewWithTag:456]).text = @"Terms of Use";

        [self.webView loadRequest:request];
    }
    else
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.icstories.com/icstories/home/policy"]];
        ((UILabel *)[self.view viewWithTag:456]).text = @"Privacy Policy";

        [self.webView loadRequest:request];
    }
}

/*============================================================================================*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*============================================================================================*/

- (IBAction)closeWindow:(id)sender
{

    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController popViewControllerAnimated:YES];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

/*============================================================================================*/

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
}
@end
