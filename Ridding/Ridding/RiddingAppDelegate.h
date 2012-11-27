//
//  RiddingAppDelegate.h
//  Ridding
//
//  Created by zys on 12-3-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiddingViewController.h"
@class RiddingViewController;

@interface RiddingAppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) RiddingViewController *rootViewController;

@property (retain, nonatomic) UINavigationController *navController;

-(bool)canLogin;
-(void)setUserInfo;
- (NSString*)getPlist:(NSString*)key;
@end
