//
//  RiddingViewController.h
//  Ridding
//
//  Created by zys on 12-3-19.
//  Copyright 2012年 __MyCompanyName__. //

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
@class RiddingViewController;
@protocol RiddingViewControllerDelegate <NSObject>

@optional
- (void)didClickLogin:(RiddingViewController*)controller;

@end


@interface RiddingViewController : BasicViewController

@property(nonatomic, retain) IBOutlet UIImageView* bgImageView;
@property(nonatomic, retain) IBOutlet UIButton* loginBtn;
@property(nonatomic, assign) id<RiddingViewControllerDelegate> delegate;
-(IBAction)clickSinaWeibo:(id)sender;
@end
