//
//  RiddingAppDelegate.h
//  Ridding
//
//  Created by zys on 12-3-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiddingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PublicViewController.h"
#import "BasicLeftViewController.h"
#import "User.h"

@interface RiddingAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
  BOOL _canGetLocation;
}

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) PublicViewController *rootViewController;

@property (nonatomic, retain) BasicLeftViewController *leftViewController;

@property (retain, nonatomic) UINavigationController *navController;


+ (RiddingAppDelegate *)shareDelegate;

- (void)setUserInfo;

- (BOOL)canLogin;

+ (BOOL)isMyFeedHome:(User *)user;

+ (void)moveLeftNavgation;

+ (void)moveRightNavgation;

+ (void)popAllNavgation;

+ (void)moveMidNavgation;

@end
