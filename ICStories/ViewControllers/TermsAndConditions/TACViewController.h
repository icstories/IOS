//
//  TACViewController.h
//  ICStories
//
//  Created by Rahul Kalavar on 06/05/14.
//  Copyright (c) 2014 Rahul Kalavar. All rights reserved.
//
/*============================================================================================*/

#import <UIKit/UIKit.h>

/*============================================================================================*/

@interface TACViewController : UIViewController

/*============================================================================================*/

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic)       BOOL                isThatTaC;

- (IBAction)closeWindow:(id)sender;

@end

/*============================================================================================*/

