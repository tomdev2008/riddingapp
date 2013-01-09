//
//  UserMap.h
//  Ridding
//
//  Created by zys on 12-3-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BasicViewController.h"
#import "AwesomeMenu.h"
#import "StaticInfo.h"
#import "ActivityView.h"
#import "SVSegmentedControl.h"
#import "Ridding.h"
#import "UserView.h"
enum SHOWTYPE {
	SHOWTEAMER = 0,
	SHOWSELF = 1,
  SHOWPHOTO = 2,
};

@interface UserMap : BasicViewController <CLLocationManagerDelegate,MKAnnotation,MKMapViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,AwesomeMenuDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UserViewDelegate>
{
  StaticInfo *_staticInfo;
  UIColor *_line_color;
  BOOL _isShowTeamers;
  BOOL _isUserTapViewOut;
  BOOL _isAnimationing;
  
  CGPoint beginPoint;
  
  Ridding *_ridding;
  CLLocation *_lastLocation;
  
  BOOL isShowDelete;
  MKAnnotationView *_showingAnnotationView;
  ActivityView *loadingView;
  
  NSTimer *_sendMyLocationTimer;
  NSTimer *_getToDestinationTimer;
  
  BOOL _routesInited;
  BOOL _zooming;
  BOOL _userInited;
  MKAnnotationView *myLocationAnnotationView;
  User *_toUser;
  UIImage *_showingImage;
  BOOL _isMyRidding;
  BOOL _isFromCamera;
  NSMutableArray *_photoArray;
  AwesomeMenu *_menu;
  SVSegmentedControl *_redSC;
  int _onlineUserCount;
}

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet UIImageView *route_view;
@property(nonatomic, retain) NSMutableArray *routes;
@property(nonatomic, strong) NSMutableArray *userArray;

@property(nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property(nonatomic, retain) IBOutlet UILabel *toDistanceLabel;
@property(nonatomic, strong) IBOutlet UIView *distanceSpeedView;

@property(nonatomic, retain) IBOutlet UIButton *showLocationButton;
@property(nonatomic, retain) IBOutlet UIButton *zoomInButton;
@property(nonatomic, retain) IBOutlet UIButton *zoomOutButton;
@property(nonatomic, retain) IBOutlet UIScrollView *userScrollView;
@property(nonatomic, retain) IBOutlet UILabel *userOnlineLabel;

- (id)initWithUser:(User*)toUser ridding:(Ridding*)ridding;

//Button响应方法
//-(IBAction)showLocationButtonClicked:(id)sender;
//-(IBAction)zoomInButtonClicked:(id)sender;
//-(IBAction)zoomOutButtonClicked:(id)sender;
//-(IBAction)backBtnClick:(id)sender;
@end
