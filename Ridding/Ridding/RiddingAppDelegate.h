//
//  RiddingAppDelegate.h
//  Ridding
//
//  Created by zys on 12-3-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiddingViewController.h"
#import "QQNRMyLocation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PublicViewController.h"
#import "BasicLeftViewController.h"
@interface RiddingAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>{
  BOOL _canGetLocation;
  QQNRMyLocation *_myLocation;
}

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) PublicViewController *rootViewController;

@property (nonatomic,retain)  BasicLeftViewController *leftViewController;

@property (retain, nonatomic) UINavigationController *navController;

@property (nonatomic,retain)  CLLocationManager *myLocationManager;


+(RiddingAppDelegate*)shareDelegate;

-(bool)canLogin;
-(void)setUserInfo;
- (NSString*)getPlist:(NSString*)key;
- (BOOL)canGetLocation;
- (QQNRMyLocation*)myLocation;
- (CLLocationManager*)myLocationManager;
- (NSString*)myLocationCity;
- (void)startUpdateMyLocation;
- (void)startUpdateMyLocationHeading;
+ (void)moveLeftNavgation;
+ (void)moveRightNavgation;
+ (void)popAllNavgation;
+ (void)moveMidNavgation;
@end
