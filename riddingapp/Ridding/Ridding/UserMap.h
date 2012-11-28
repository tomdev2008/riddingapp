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
#import "RequestUtil.h"
#import "StaticInfo.h"
#import "ActivityView.h"
#import "SVSegmentedControl.h"
#import "ActivityInfo.h"
enum SHOWTYPE {
	SHOWTEAMER = 0,
	SHOWSELF = 1,
  SHOWPHOTO = 2,
};

@interface UserMap : BasicViewController <CLLocationManagerDelegate,MKAnnotation,MKMapViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,AwesomeMenuDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
  RequestUtil *requestUtil;
  StaticInfo *staticInfo;
  UIColor *line_color;
  bool _isShowTeamers;
  bool _isUserTapViewOut;
  bool _isAnimationing;
  
  CGPoint beginPoint;
  
  NSString *_riddingId;
  CLLocation *lastLocation;
  
  bool isShowDelete;
  MKAnnotationView *_showingAnnotationView;
  ActivityView *loadingView;
  
  NSTimer *_sendMyLocationTimer;
  NSTimer *_getToDestinationTimer;
  
  BOOL _routesInited;
  bool _zooming;
  bool _userInited;
  MKAnnotationView *myLocationAnnotationView;
  User *_nowUser;
  NSNumber *_riddingStatus;
  AwesomeMenu *_menu;
  UIImage *_showingImage;
  BOOL _isMyRidding;
  BOOL _isFromCamera;
  SVSegmentedControl *_redSC;
  ActivityInfo *_info;
}

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet UIImageView *route_view;
@property(nonatomic, retain) UIColor *line_color;
@property(nonatomic, retain) NSMutableArray *routes;
@property(nonatomic, retain) RequestUtil *requestUtil;
@property(nonatomic, strong) NSMutableArray *userArray;
@property(nonatomic, retain) StaticInfo *staticInfo;
@property(nonatomic, retain) CLLocation *lastLocation;
@property(nonatomic, retain) CLLocationManager *myLocation;

@property(nonatomic, strong) ActivityView *loadingView;
@property(nonatomic) bool isShowDelete;

@property(nonatomic, retain) IBOutlet UIButton *backBtn;
@property(nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property(nonatomic, retain) IBOutlet UILabel *toDistanceLabel;
@property(nonatomic, strong) IBOutlet UIView *distanceSpeedView;

@property(nonatomic, retain) IBOutlet UIButton *showLocationButton;
@property(nonatomic, retain) IBOutlet UIButton *zoomInButton;
@property(nonatomic, retain) IBOutlet UIButton *zoomOutButton;
@property(nonatomic, retain) IBOutlet UIScrollView *userScrollView;
@property(nonatomic, retain) IBOutlet UILabel *userOnlineLabel;

- (id)initWithUser:(User*)nowUser info:(ActivityInfo*)info riddingStatus:(NSNumber*)riddingStatus;

//Button响应方法
-(IBAction)showLocationButtonClicked:(id)sender;
-(IBAction)zoomInButtonClicked:(id)sender;
-(IBAction)zoomOutButtonClicked:(id)sender;
-(IBAction)backBtnClick:(id)sender;
@end
