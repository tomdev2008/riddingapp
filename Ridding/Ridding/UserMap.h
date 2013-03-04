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
#import "StaticInfo.h"
#import "Ridding.h"
#import "UserView.h"
#import "AnnotationPhotoView.h"
enum SHOWTYPE {
  SHOWTEAMER = 0,
  SHOWSELF = 1,
  SHOWPHOTO = 2,
};

@interface UserMap : BasicViewController <CLLocationManagerDelegate, MKAnnotation, MKMapViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UserViewDelegate,AnnotationPhotoViewDelegate> {
  StaticInfo *_staticInfo;
  
  BOOL _isShowTeamers;
  BOOL _isUserTapViewOut;
  BOOL _isAnimationing;

  CGPoint beginPoint;

  Ridding *_ridding;
  CLLocation *_lastLocation;

  BOOL isShowDelete;
  MKAnnotationView *_showingAnnotationView;

  NSTimer *_sendMyLocationTimer;
  

  BOOL _routesInited;
  BOOL _zooming;
  BOOL _userInited;
  MKAnnotationView *myLocationAnnotationView;
  User *_toUser;
  BOOL _isMyRidding;
  BOOL _isFromCamera;
  NSMutableArray *_photoArray;
  int _onlineUserCount;
  UILabel *_teamerLabel;
  UIImageView *_teamerView;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIImageView *route_view;
@property (nonatomic, retain) NSMutableArray *routes;
@property (nonatomic, strong) NSMutableArray *userArray;

@property (nonatomic, retain) IBOutlet UIScrollView *userScrollView;
@property (nonatomic, retain) IBOutlet UIView *rightView;

@property (nonatomic, retain) IBOutlet UIButton *takePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton *mySelfBtn;
@property (nonatomic, retain) IBOutlet UIButton *photoBtn;
@property (nonatomic, retain) IBOutlet UIButton *teamerBtn;

@property (nonatomic, retain) IBOutlet UIImageView *btnBgView;


- (id)initWithUser:(User *)toUser ridding:(Ridding *)ridding;

//Button响应方法
//-(IBAction)showLocationButtonClicked:(id)sender;
//-(IBAction)zoomInButtonClicked:(id)sender;
//-(IBAction)zoomOutButtonClicked:(id)sender;
//-(IBAction)backBtnClick:(id)sender;
@end
