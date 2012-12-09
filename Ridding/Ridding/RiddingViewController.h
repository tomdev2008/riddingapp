//
//  RiddingViewController.h
//  Ridding
//
//  Created by zys on 12-3-19.
//  Copyright 2012年 __MyCompanyName__. //

#import <UIKit/UIKit.h>
#import "BasicViewController.h"


@interface RiddingViewController : BasicViewController

@property(nonatomic, retain) IBOutlet UIImageView* bgImageView;
@property(nonatomic, retain) IBOutlet UIButton* loginBtn;

-(IBAction)clickSinaWeibo:(id)sender;
@end
