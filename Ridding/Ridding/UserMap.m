//
//  UserMap.m
//  Ridding
//
//  Created by zys on 12-3-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserMap.h"
#import "UIColor+XMin.h"
#import "PhotoAnnotation.h"
#import "QQNRFeedViewController.h"
#import "PhotoDescViewController.h"
#import "RiddingLocation.h"
#import "UIImageView+WebCache.h"
#import "MapUtil.h"
#import "Utilities.h"
#import "StartAnnotation.h"
#import "EndAnnotation.h"
#import "UIImage+UIImage_Retina4.h"
#import "InvitationViewController.h"
#import "QQNRServerTaskQueue.h"
#import "SVProgressHUD.h"
#import "QQNRImagesScrollVCTL.h"
#import "RiddingLocationDao.h"
#import "MyLocationManager.h"
#import "PhotoAnnotationView.h"
#import "BasicPhotoAnnotation.h"
#import "Weather.h"
@interface UserMap ()

@end

@implementation UserMap
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _staticInfo = [StaticInfo getSinglton];

  }
  return self;
}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}

- (id)initWithUser:(User *)toUser ridding:(Ridding *)ridding {

  self = [super init];
  if (self) {
    _toUser = toUser;
    _ridding = ridding;
  }
  return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {

  _routes = [[NSMutableArray alloc] init];
  self.hasLeftView = FALSE;
  _isMyRidding = FALSE;
  if ([StaticInfo getSinglton].user.userId == _toUser.userId) {
    _isMyRidding = TRUE;
  }
  if (_isMyRidding) {
    [self myLocationQuartz];
  }
  self.mapView.userInteractionEnabled=YES;
  UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewClick:)]; //动态添加点击操作
  [self.mapView addGestureRecognizer:viewTap];
  _isUserTapViewOut = FALSE;
  _isAnimationing = FALSE;
  _routesInited = FALSE;
  _isShowTeamers = FALSE;
  _userInited = FALSE;

  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];
  
  UIImageView *distanceIcon=[[UIImageView alloc]initWithFrame:CGRectMake(105, 7, 25, 25)];
  distanceIcon.image=UIIMAGE_FROMPNG(@"qqnr_map_narbar_icon_mileage");
  [self.barView addSubview:distanceIcon];
  
  UILabel *distanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(135, 8, 100, 25)];
  distanceLabel.text=[_ridding.map totalDistanceToKm];
  distanceLabel.textColor=[UIColor getColor:@"005c4e"];
  distanceLabel.backgroundColor=[UIColor clearColor];
  distanceLabel.font=[UIFont systemFontOfSize:18];
  distanceLabel.shadowColor = [UIColor getColor:@"4cd1c5"];
  distanceLabel.shadowOffset = CGSizeMake(0, 1.0);
  [self.barView addSubview:distanceLabel];

  _teamerView=[[UIImageView alloc]initWithFrame:CGRectMake(250, 10, 25, 25)];
  _teamerView.image=UIIMAGE_FROMPNG(@"qqnr_map_narbar_icon_onlinemember");
  _teamerView.hidden=YES;
  [self.barView addSubview:_teamerView];
  
  _teamerLabel =[[UILabel alloc]initWithFrame:CGRectMake(280, 8, 40, 25)];
  _teamerLabel.hidden=YES;
  _teamerLabel.textColor=[UIColor getColor:@"005c4e"];
  _teamerLabel.backgroundColor=[UIColor clearColor];
  _teamerLabel.font=[UIFont systemFontOfSize:18];
  _teamerLabel.shadowColor = [UIColor getColor:@"4cd1c5"];
  _teamerLabel.shadowOffset = CGSizeMake(0, 1.0);
  [self.barView addSubview:_teamerLabel];
  
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  if(![prefs boolForKey:kStaticInfo_First_myRidding]){
    UIButton *imageView=[UIButton buttonWithType:UIButtonTypeCustom];
    imageView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [imageView setImage:[UIImage retina4ImageNamed:@"qqnr_dl_first" type:@"png"] forState:UIControlStateNormal];
    [imageView addTarget:self action:@selector(imageViewCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageView];
  }
  _photoArray = [[NSMutableArray alloc] init];
  [super viewDidLoad];
}

- (void)imageViewCilck:(id)sender{
  UIView *view=(UIView*)sender;
  [view removeFromSuperview];
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs setBool:YES forKey:kStaticInfo_First_myRidding];
}

- (void)viewDidAppear:(BOOL)animated {

  [_sendMyLocationTimer fire];
  [super viewDidAppear:animated];
  dispatch_async(dispatch_queue_create("download", NULL), ^{
    dispatch_async(dispatch_get_main_queue(), ^{
      [self download];
    });
  });
}

- (void)download {

  if (!_userInited && _isMyRidding) {
    [SVProgressHUD showWithStatus:@"初始化数据中"];
    //异步去加载用户
    [self removeAllUserView];
    [self setUsers];
  } else {
    _userInited = TRUE;
  }
  if (!_routesInited) {
    [SVProgressHUD showWithStatus:@"初始化数据中"];
    //异步去画地图
#warning asdf
    [self drawMyRoutes];
    //[self drawRoutes];
  }
}

- (void)viewWillDisappear:(BOOL)animated {

  [_sendMyLocationTimer invalidate];
  [super viewWillDisappear:animated];
}


- (void)setUsers {

  dispatch_queue_t q;
  q = dispatch_queue_create("setUsers", NULL);
  dispatch_async(q, ^{
    NSArray *array = [self.requestUtil getUserList:_ridding.riddingId];
    if (array && [array count] > 0) {
      for (NSDictionary *dic in array) {
        User *user = [[User alloc] initWithJSONDic:[dic objectForKey:keyUser]];
        if (_staticInfo.user.userId == user.userId) {
          if ([Ridding isLeader:user.userRole]) {
            _staticInfo.user.isLeader = TRUE;
          } else {
            _staticInfo.user.isLeader = FALSE;
          }
        }
        [self.userArray addObject:user];
      }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [self setUserScrollView];
      _userInited = TRUE;
      if (_routesInited && _userInited) {
        [SVProgressHUD dismiss];
      }
    });
  });
}



- (void)myLocationQuartz {
  
  _sendMyLocationTimer = [NSTimer scheduledTimerWithTimeInterval:sendMyLocationTime target:self selector:@selector(sendMyLocationQuartz) userInfo:nil repeats:YES];
  [_sendMyLocationTimer fire];
}



//定时发送我的当前位置
- (void)sendMyLocationQuartz {

  MyLocationManager *myLocationManager = [MyLocationManager getSingleton];
  dispatch_queue_t q;
  q = dispatch_queue_create("sendMyLocationQuartz", NULL);
  dispatch_async(q, ^{
    [myLocationManager startUpdateMyLocation:^(QQNRMyLocation *location) {
      if (location == nil) {
        [SVProgressHUD showSuccessWithStatus:@"请开启定位服务以定位到您的位置" duration:2.0];
      } else {
        
        MKCoordinateRegion theRegion;
        theRegion.center = location.location.coordinate;
        CLLocationDegrees latitude = theRegion.center.latitude;
        CLLocationDegrees longtitude = theRegion.center.longitude;
        double speed = 0.0;
        [self.requestUtil sendAndGetAnnotation:_ridding.riddingId latitude:latitude longtitude:longtitude status:1 speed:speed isGetUsers:_isShowTeamers ? 1 : 0];
        
      }
    }];
  });
}

//画路线
- (void)drawRoutes {

  dispatch_queue_t q;
  q = dispatch_queue_create("drawRoutes", NULL);
  dispatch_async(q, ^{
    NSArray *tempRoutes=(NSArray*)[[StaticInfo getSinglton].routesDic objectForKey:LONGLONG2NUM(_ridding.riddingId)];
    [_routes addObjectsFromArray:tempRoutes];
    if(!_routes||[_routes count]==0){
      
      NSArray *routeArray = [RiddingLocationDao getRiddingLocations:_ridding.riddingId beginWeight:0];
      if ([routeArray count] > 0) {
        for (RiddingLocation *location in routeArray) {
          CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longtitude];
          [self.routes addObject:loc];
        }
      } else {
        //如果数据库中存在，那么取数据库中的地图路径，如果不存在，http去请求服务器。
        //数据库中取出是mapTaps或者points
        NSMutableDictionary *map_dic = [self.requestUtil getMapMessage:_ridding.riddingId userId:_staticInfo.user.userId];
        Map *map = [[Map alloc] initWithJSONDic:[map_dic objectForKey:keyMap]];
        NSArray *array = map.mapPoint;
        [[MapUtil getSinglton] calculate_routes_from:map.mapTaps map:map];
        self.routes = [[MapUtil getSinglton] decodePolyLineArray:array];
        [RiddingLocationDao setRiddingLocationToDB:self.routes riddingId:_ridding.riddingId];
      }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      if (self) {
        [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:[UIColor getColor:lineColor] routes:self.routes width:5.0];
        [[MapUtil getSinglton] center_map:self.mapView routes:self.routes];
        CLLocation *startLocation = [self.routes objectAtIndex:0];
        [self addStartAnnotationWithcoordinateX:startLocation.coordinate.latitude coordinateY:startLocation.coordinate.longitude Title:@"title1" Subtitle:@"subtitle1"];
        CLLocation *endLocation = [self.routes objectAtIndex:[self.routes count] - 1];
        [self addEndAnnotationWithcoordinateX:endLocation.coordinate.latitude coordinateY:endLocation.coordinate.longitude Title:@"title2" Subtitle:@"subtitle2"];
        _routesInited = YES;
        if (_routesInited && _userInited) {
          [SVProgressHUD dismiss];
        }
      }
    });
  });
}


//画路线
- (void)drawMyRoutes {
  
  dispatch_queue_t q;
  q = dispatch_queue_create("drawRoutes", NULL);
  dispatch_async(q, ^{
    dispatch_async(dispatch_get_main_queue(), ^{
      if (self) {
        if([[[MyLocationManager getSingleton] locationArray]count]>0){
          [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:[UIColor blackColor] routes:[[MyLocationManager getSingleton] locationArray] width:5.0];
          [[MapUtil getSinglton] center_map:self.mapView routes:[[MyLocationManager getSingleton] locationArray]];
        }
         [SVProgressHUD dismiss];
      }
    });
  });
}



- (void)addStartAnnotationWithcoordinateX:(double)coorX coordinateY:(double)coorY
                                    Title:(NSString *)title Subtitle:(NSString *)subtitle {

  CLLocationCoordinate2D startPoint;
  if (coorX && coorY) {
    startPoint.latitude = coorX;
    startPoint.longitude = coorY;
    StartAnnotation *_startAnnotation = [[StartAnnotation alloc] initWithCoords:startPoint];

    if (title != NULL)
      _startAnnotation.title = title;
    if (subtitle != NULL)
      _startAnnotation.subtitle = subtitle;
    [self.mapView addAnnotation:_startAnnotation];
    
  }
}

- (void)addEndAnnotationWithcoordinateX:(double)coorX coordinateY:(double)coorY
                                  Title:(NSString *)title Subtitle:(NSString *)subtitle {

  CLLocationCoordinate2D endPoint;
  if (coorX && coorY) {
    endPoint.latitude = coorX;
    endPoint.longitude = coorY;
    EndAnnotation *_endAnnotation = [[EndAnnotation alloc] initWithCoords:endPoint];
    if (title != NULL)
      _endAnnotation.title = title;
    if (subtitle != NULL)
      _endAnnotation.subtitle = subtitle;
    [self.mapView addAnnotation:_endAnnotation];
  }
}

//插入用户位置的异步回调
#pragma requestUtil delegate
- (void)asyncReturnDic:(NSDictionary *)dic {
 
  NSArray *userArray = [dic objectForKey:@"data"];
  if (dic == nil || self.userArray == nil) {
    return;
  }
  if(!_isShowTeamers){
    return;
  }
  NSMutableDictionary *mulDic = [[NSMutableDictionary alloc] init];
  for (NSDictionary *location in userArray) {
    User *user = [[User alloc] initWithJSONDic:[location objectForKey:keyUser]];
    [mulDic setObject:user forKey:LONGLONG2NUM(user.userId)];
  }
  NSMutableDictionary *annotationDic = [[NSMutableDictionary alloc] init];
  NSArray *annotations = [self.mapView annotations];
  if (annotations && [annotations count] > 0) {
    for (id <MKAnnotation> annotation in annotations) {
      if ([annotation isKindOfClass:[UserAnnotation class]]) {
        UserAnnotation *userAnnotation = (UserAnnotation *) annotation;
        [annotationDic setObject:userAnnotation forKey:LONGLONG2NUM(userAnnotation.userId)];
      }
    }
  }
  dispatch_queue_t q;
  q = dispatch_queue_create("updateAnnotations", NULL);
  
  dispatch_async(q, ^{
    for (User *user in self.userArray) {
      //如果是当前用户
      if (user.userId == _staticInfo.user.userId) {
        continue;
      }
      User *serverUser = [mulDic objectForKey:LONGLONG2NUM(user.userId)];
      
      if (serverUser != nil) {
        CLLocationDegrees latitude = serverUser.latitude;
        CLLocationDegrees longtitude = serverUser.longtitude;
        CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(latitude, longtitude);
        user.speed = serverUser.speed;
        user.status = serverUser.status;
        UserAnnotation *userAnnotation = [annotationDic objectForKey:LONGLONG2NUM(user.userId)];
        if (!userAnnotation) {
          userAnnotation = [[UserAnnotation alloc] init];
          userAnnotation.userId = user.userId;
          dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotation:userAnnotation];
          });
        }
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.savatorUrl]];
        userAnnotation.headImage = [UIImage imageWithData:imageData];
        userAnnotation.coordinate = coordinate2D;
        userAnnotation.subtitle = [NSString stringWithFormat:@"更新时间:%@", serverUser.timeBefore];
        userAnnotation.title = user.name;
        user.annotation = userAnnotation;
      }
    }
  });

  _onlineUserCount = 0;
  for (UIView *view in [self.userScrollView subviews]) {
    if ([view isKindOfClass:[UserView class]]) {
      UserView *userView = (UserView *) view;
      User *user = [mulDic objectForKey:LONGLONG2NUM(userView.user.userId)];
      userView.user.latitude = user.latitude;
      userView.user.longtitude = user.longtitude;
      [userView changeStatus:user.status];
      if (user.status == 1) {
        _onlineUserCount++;
      }
    }
  }
  
  _teamerView.hidden=NO;
  _teamerLabel.hidden=NO;
  _teamerLabel.text=[NSString stringWithFormat:@"%d/%d",_onlineUserCount, [self.userArray count]];
  
}

- (void)updatePhotoAnnotation {

  [SVProgressHUD showWithStatus:@"获取图片中"];
  dispatch_async(dispatch_queue_create("updatePhotoAnnotation", NULL), ^{
    [_photoArray removeAllObjects];
    NSArray *serverArray = [self.requestUtil getUploadedPhoto:_ridding.riddingId limit:-1 lastUpdateTime:-1];
    
    if ([serverArray count] > 0) {
      for (int i=0;i<[serverArray count];i++) {
        NSDictionary *dic=[serverArray objectAtIndex:i];
        RiddingPicture *picture = [[RiddingPicture alloc] initWithJSONDic:[dic objectForKey:keyRiddingPicture]];
        if (picture) {
          CLLocationDegrees latitude = picture.latitude;
          CLLocationDegrees longtitude = picture.longtitude;
          dispatch_async(dispatch_get_main_queue(), ^{
            BasicPhotoAnnotation *basicPhotoAnnotation = [[BasicPhotoAnnotation alloc] initWithLatitude:latitude andLongitude:longtitude];
            basicPhotoAnnotation.index = i;
            [self.mapView addAnnotation:basicPhotoAnnotation];
            [_photoArray addObject:picture];
            if(i==0){
              if([Utilities deviceVersion]>=6.0){
                [self.mapView selectAnnotation:basicPhotoAnnotation animated:YES];
              }else{
                dispatch_async(dispatch_queue_create("drawRoutes", NULL), ^{
                  [NSThread sleepForTimeInterval:0.5];
                  dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView selectAnnotation:basicPhotoAnnotation animated:YES];
                    
                  });
                });
              }
              MKCoordinateRegion region;
              region.center = basicPhotoAnnotation.coordinate;
              region.span = self.mapView.region.span;
              [self.mapView setRegion:region animated:YES];
              
            }
          });
        }
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
      });
    }else {
      dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:@"您还没有照片,赶紧去拍一张" duration:1.0];
      });
    }
  });
}

- (void)removeAllAnnotations {

  if (self.mapView) {
    NSArray *annotations = [self.mapView annotations];
    if (annotations && [annotations count] > 0) {
      for (id <MKAnnotation> annotation in annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]] && ![annotation isKindOfClass:[StartAnnotation class]] && ![annotation isKindOfClass:[EndAnnotation class]]) {
          [self.mapView removeAnnotation:annotation];
        }
      }
    }
  }
}

- (void)removeAllCalloutAnnotations {

    NSArray *annotations = [self.mapView annotations];
    if (annotations && [annotations count] > 0) {
      for (id <MKAnnotation> annotation in annotations) {
        if ([annotation isKindOfClass:[PhotoAnnotationView class]]) {
          [self.mapView removeAnnotation:annotation];
        }
      }
    }
}

-(void)deselectAllAnnotations{
  NSArray* annotations=[self.mapView annotations];
  if(annotations&&[annotations count]>0){
    for(id<MKAnnotation> annotation in annotations){
      if (![annotation isKindOfClass:[MKUserLocation class]]&&![annotation isKindOfClass:[StartAnnotation class]]&&![annotation isKindOfClass:[EndAnnotation class]]){
          [self.mapView deselectAnnotation:annotation animated:YES];
      }
    }
  }
}

/**
 **
 **点击操作
 **/
#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

  UITouch *touch = [touches anyObject];
  beginPoint = [touch locationInView:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}

//animation停止
- (void)myAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {

  _isAnimationing = FALSE;
}

/**
 **(begin)
 **userScrollView相关模块
 **/
//插入用户滚动view
- (void)setUserScrollView {

  isShowDelete = FALSE;
  int width = 45;
  int height = 51;
  int index = 1;
  int addViewCount = 1;
  //如果不是队长是成员
  if (!_staticInfo.user.isLeader || [_ridding isEnd]) {
    addViewCount = 0;
    index = 0;
  }
  UIImageView *imageView = [[UIImageView alloc] initWithImage:UIIMAGE_FROMPNG(@"qqnr_pd_comment_tabbar_bg")];
  [self.userScrollView addSubview:imageView];
  if (self.userArray && [self.userArray count] > 4) {
    [imageView setFrame:CGRectMake(-100, 0, self.userScrollView.frame.size.width+300, self.userScrollView.frame.size.height)];
  }
  
  if (_staticInfo.user.isLeader && ![_ridding isEnd]) {
    UIButton *actionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame=CGRectMake(10, 13, 35, 25);
    [actionBtn setImage:UIIMAGE_FROMPNG(@"qqnr_map_addmember_icon_add") forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(actionViewClick:) forControlEvents:UIControlEventTouchUpInside];
    actionBtn.showsTouchWhenHighlighted=YES;
    [self.userScrollView addSubview:actionBtn];
  }
  
  self.userScrollView.contentSize = CGSizeMake(width, height);
  self.userScrollView.bounces = YES;
  if (self.userArray && [self.userArray count] > 0) {
    for (User *user in self.userArray) {
      UserView *userView = [[UserView alloc] initWithFrame:CGRectMake(10 + (width) * (index++), 0, width, height)];
      userView.user = user;
      userView.delegate = self;
      userView = [userView init];
      userView.backgroundColor = [UIColor clearColor];
      if (_staticInfo.user.isLeader) {
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longViewClick:)];
        [userView addGestureRecognizer:longTap];
        userView.userInteractionEnabled = YES;
      }

      [self.userScrollView addSubview:userView];
    }
    self.userScrollView.contentSize = CGSizeMake((width) * ([self.userArray count] + addViewCount), height);
  }


}
#pragma mark - Animation for Member Views
//点击地图后，scrollview隐藏显示的信息操作
- (void)mapViewClick:(UITapGestureRecognizer *)gestureRecognize {
  
  if (_isUserTapViewOut == TRUE) {
    [self membersViewDownToUp];
    _isUserTapViewOut = FALSE;
    NSArray *array = [self.userScrollView subviews];
    if (array && [array count] > 0) {
      for (UIView *view in array) {
        if ([view isKindOfClass:[UserView class]]) {
          UserView *userView = (UserView *) view;
          [userView hideDeleteBtn];
        }
      }
    }
    isShowDelete = FALSE;
  }
  [self removeAllCalloutAnnotations];
  [self deselectAllAnnotations];
}




#pragma mark - UserScrollView animate
//长按
- (void)longViewClick:(UITapGestureRecognizer *)gestureRecognize {

  isShowDelete = TRUE;
  NSArray *array = [self.userScrollView subviews];
  if (array && [array count] > 0) {
    for (UIView *view in array) {
      if ([view isKindOfClass:[UserView class]]) {
        UserView *userView = (UserView *) view;
        [userView showDeleteBtn];
      }
    }
  }
}

#pragma UserView Delegate
- (void)deleteBtnClick:(UserView *)userView {

  [MobClick event:@"2012070205"];
  CGFloat x = userView.frame.origin.x;
  [self.requestUtil deleteRiddingUser:_ridding.riddingId deleteUserIds:[[NSArray alloc] initWithObjects:LONGLONG2NUM(userView.user.userId), nil]];

  if (self.userScrollView) {
    [userView removeFromSuperview];
    [self.userScrollView setContentSize:CGSizeMake(self.userScrollView.contentSize.width - userView.frame.size.width, userView.frame.size.height)];
    NSArray *userViews = [self.userScrollView subviews];
    for (UIView *view in userViews) {
      if (view.frame.origin.x > x) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        [UIView setAnimationDelegate:self];
        [view setFrame:CGRectMake(view.frame.origin.x - view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
        [UIView commitAnimations];
      }
    }
  }

  if (self.userArray && [self.userArray count] > 0) {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (User *user in self.userArray) {
      if (user.userId != userView.user.userId) {
        [tempArray addObject:user];
      }
    }
    self.userArray = tempArray;
  }
  
  _teamerLabel.text=[NSString stringWithFormat:@"%d/%d",_onlineUserCount, [self.userArray count]];
}

- (void)avatorBtnClick:(UserView *)userView {

  if (userView.user.userId == _staticInfo.user.userId) {
    return;
  }
  [MobClick event:@"2012070204"];
  if (self.userArray) {
    for (User *user in self.userArray) {
      if (userView.user.userId == user.userId) {
        MKCoordinateRegion region;
        region.center.latitude = userView.user.latitude;
        region.center.longitude = userView.user.longtitude;
        region.span = self.mapView.region.span;
        [self.mapView setRegion:region animated:YES];
        [self.mapView selectAnnotation:user.annotation animated:YES];
        break;
      }
    }
  }
}

- (void)actionViewClick:(UITapGestureRecognizer *)gestureRecognize {

  [MobClick event:@"2012070203"];
  _userInited = FALSE;
  InvitationViewController *invitationView = [[InvitationViewController alloc] initWithNibName:@"InvitationViewController" bundle:nil riddingId:_ridding.riddingId nowTeamers:self.userArray];
  [self.navigationController pushViewController:invitationView animated:YES];
  [self membersViewDownToUp];
}

- (void)membersViewDownToUp {

  if (!_userInited || !_routesInited) {
    return;
  }
  if (self.userScrollView.frame.origin.y < 0) {
    return;
  }
  _isAnimationing = YES;
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3f];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(myAnimationDidStop:finished:context:)];
  [self.userScrollView setFrame:CGRectMake(0, SCREEN_STATUS_BAR -  self.userScrollView.frame.size.height, self.view.frame.size.width, self.userScrollView.frame.size.height)];
  [UIView commitAnimations];
  _isUserTapViewOut = FALSE;
  
}

- (void)membersViewUpToDown {

  if (self.userScrollView.frame.origin.y > 0) {
    return;
  }
  _isAnimationing = YES;

  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3f];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(myAnimationDidStop:finished:context:)];
  [self.userScrollView setFrame:CGRectMake(0, SCREEN_STATUS_BAR, self.userScrollView.frame.size.width, self.userScrollView.frame.size.height)];
  [UIView commitAnimations];
  
  _isUserTapViewOut = TRUE;
}

- (void)removeAllUserView {

  if (self && self.userScrollView && [self.userScrollView.subviews count] > 0) {
    NSArray *array = [self.userScrollView subviews];
    for (UIView *view in array) {
      [view removeFromSuperview];
    }
  }
  [self removeAllAnnotations];
  self.userArray = [[NSMutableArray alloc] init];
}


#pragma mark CLLocationManager Heading Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {

  if (newHeading.headingAccuracy > 0) {
    CGFloat heading = (1.0f * M_PI * newHeading.trueHeading) / 180.f;
    myLocationAnnotationView.transform = CGAffineTransformMakeRotation(heading);
  }
}

#pragma mark mapView delegate functions

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {

  self.route_view.hidden = YES;
}

//地图移动结束后的操作
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

  [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:[UIColor blackColor] routes:[[MyLocationManager getSingleton] locationArray] width:5.0];
#warning asdf
  self.route_view.hidden = NO;
  [self.route_view setNeedsDisplay];
}

//选中某个annotation时
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
  [self deselectAllAnnotations];
  //添加点击弹出图
  if ([view.annotation isKindOfClass:[BasicPhotoAnnotation class]]) {
    [self removeAllCalloutAnnotations];
    BasicPhotoAnnotation *basicPhotoAnnotation = (BasicPhotoAnnotation *) view.annotation;
    CLLocationCoordinate2D location = basicPhotoAnnotation.coordinate;
    PhotoAnnotation *photoAnnotation = [[PhotoAnnotation alloc] initWithLatitude:location.latitude andLongitude:location.longitude];
    photoAnnotation.index = basicPhotoAnnotation.index;
    
    [self.mapView addAnnotation:photoAnnotation];
    _showingAnnotationView = view;
  }
}

//取消选中某个annotation时
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
  
}

//在addAnnotation的时候调用
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {

  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  if ([annotation isKindOfClass:[StartAnnotation class]]) {
    MKAnnotationView *newAnnotation = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationStart"];
    newAnnotation.image = UIIMAGE_FROMPNG(@"qqnr_dl_map_icon_start");
    newAnnotation.canShowCallout = NO;
    return newAnnotation;
  }

  if ([annotation isKindOfClass:[EndAnnotation class]]) {
    MKAnnotationView *newAnnotation = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationEnd"];
    newAnnotation.image = UIIMAGE_FROMPNG(@"qqnr_dl_map_icon_end");
    newAnnotation.canShowCallout = NO;
    return newAnnotation;
  }

  // 处理我们自定义的Annotation
  if ([annotation isKindOfClass:[UserAnnotation class]]) {
    MKAnnotationView *customPinView = [[MKAnnotationView alloc]
        initWithAnnotation:annotation reuseIdentifier:@"UserAnnotationIdentifier"];

    [customPinView setCanShowCallout:YES]; //很重要，运行点击弹出标签
    customPinView.draggable = NO;
    UserAnnotation *userAnnotation = (UserAnnotation *) annotation;
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    headImage.image = userAnnotation.headImage;
    customPinView.leftCalloutAccessoryView = headImage; //设置最左边的头像

//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    [rightButton addTarget:self action:@selector(showDetails)  //点击右边的按钮之后，显示另外一个页面
//          forControlEvents:UIControlEventTouchUpInside];
//
//    customPinView.rightCalloutAccessoryView = rightButton;
    customPinView.image = UIIMAGE_FROMPNG(@"qqnr_map_icon_member");
    customPinView.opaque = YES;
    return customPinView;
  }
  
  if ([annotation isKindOfClass:[BasicPhotoAnnotation class]]) {
    
    MKAnnotationView *pinView = (MKAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"PhotoAnnotationIdentifier"];
    if(!pinView){
      pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                reuseIdentifier:@"PhotoAnnotationIdentifier"];
      [pinView setCanShowCallout:NO];
      [pinView setDraggable:NO];
      pinView.image=UIIMAGE_FROMPNG(@"qqnr_map_icon_photo");
    }else{
      pinView.annotation=annotation;
    }
    
    return pinView;
  }
  
  if ([annotation isKindOfClass:[PhotoAnnotation class]]) {
    PhotoAnnotationView *annotationView = (PhotoAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"PhotoAnnotationView"];
    if (!annotationView) {
      annotationView = [[PhotoAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PhotoAnnotationView"];
    }
    PhotoAnnotation *photoAnnotation=(PhotoAnnotation*)annotation;
    AnnotationPhotoView  *view = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationPhotoView" owner:self options:nil] objectAtIndex:0];
    view.index=photoAnnotation.index;
    view.delegate=self;
    RiddingPicture *picture=[_photoArray objectAtIndex:photoAnnotation.index];
    [view initViewWithPhoto:picture];
    [annotationView.contentView addSubview:view];
    return annotationView;
  }
  return nil;
}

- (void)showDetails {
  //显示用户详情,annotationview
}

- (void)photoClick:(AnnotationPhotoView*)view{
  
  QQNRImagesScrollVCTL *vctl = [[QQNRImagesScrollVCTL alloc] initWithNibName:@"QQNRImagesScrollVCTL" bundle:nil startPageIndex:view.index];
  vctl.photoArray = _photoArray;
  [self.navigationController pushViewController:vctl animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

  return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Button Responser IBAction
- (IBAction)weatherBtnClick:(id)sender{
  for(NSString *taps in _ridding.map.mapTaps){
    NSDictionary *dic= [self.requestUtil weatherRequest:taps];
    NSArray *dateArray=[dic objectForKey:keyWeather];
    Weather *weather=[[Weather alloc]initWithJSONDic:[dateArray objectAtIndex:0]];
  }
}

- (IBAction)backBtnClick:(id)sender {

  if (self) {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (IBAction)showLocationButtonClicked:(id)sender {

  if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    [_sendMyLocationTimer invalidate];
    return;
  }
  if (![_sendMyLocationTimer isValid]) {
    [_sendMyLocationTimer fire];
  }
  if(_zooming){
    return;
  }
  _zooming=TRUE;
  MKCoordinateRegion region;
  region.center = [self.mapView userLocation].coordinate;
  region.span = self.mapView.region.span;
  [self.mapView setRegion:region animated:YES];
  _zooming=FALSE;
}

- (IBAction)zoomInButtonClicked:(id)sender {

  [MobClick event:@"2012070202"];
  if (_zooming) {
    return;
  }
  MKCoordinateRegion region = self.mapView.region;
  region.span.latitudeDelta = region.span.latitudeDelta / 2;
  region.span.longitudeDelta = region.span.longitudeDelta / 2;
  _zooming = TRUE;
  if (region.span.latitudeDelta > 0 && region.span.longitudeDelta > 0) {
    [self.mapView setRegion:region animated:YES];
  }
  _zooming = FALSE;

}

- (IBAction)zoomOutButtonClicked:(id)sender {

  [MobClick event:@"2012070201"];
  MKCoordinateRegion region = self.mapView.region;
  region.span.latitudeDelta = region.span.latitudeDelta * 2;
  region.span.longitudeDelta = region.span.longitudeDelta * 2;
  if (_zooming || region.span.latitudeDelta > 200) {
    return;
  }
  _zooming = TRUE;
  [self.mapView setRegion:region animated:YES];
  _zooming = FALSE;
}

- (void)resetAllBtn{
  [self.takePhotoBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [self.takePhotoBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
  [self.mySelfBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [self.mySelfBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
  [self.teamerBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [self.teamerBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
  [self.photoBtn setBackgroundImage:nil forState:UIControlStateNormal];
  [self.photoBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
}

- (IBAction)takePhotoAction:(id)sender{
  
  [self.takePhotoBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_map_tabbar_iconbackground_hl") forState:UIControlStateNormal];
  [self.takePhotoBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_map_tabbar_iconbackground_hl") forState:UIControlStateHighlighted];
  [self showActionSheet];
}

- (IBAction)showPicAction:(id)sender{
  [self checkShowIOS5Tips];
  [MobClick event:@"2013022509"];
  [self doAnimate:sender];
  [self removeAllAnnotations];
  _isShowTeamers = FALSE;
  _teamerLabel.hidden=YES;
  _teamerView.hidden=YES;
  [self updatePhotoAnnotation];
  [self membersViewDownToUp];
}

- (void)checkShowIOS5Tips{
  if([Utilities deviceVersion]<6.0){
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs boolForKey:kStaticInfo_Ios5Tips_ShowPhoto]) {
      UIAlertView *view= [[UIAlertView alloc]initWithTitle:@"小提示" message:@"您的手机版本低于ios6,查看照片大图需要长按" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了", nil];
      [view show];
      [prefs setBool:YES forKey:kStaticInfo_Ios5Tips_ShowPhoto];
    }
    
  }
}

- (IBAction)showMySelfAction:(id)sender{
  [MobClick event:@"2013022510"];
  [self doAnimate:sender];
  [self removeAllAnnotations];
  _teamerLabel.hidden=YES;
  _teamerView.hidden=YES;
  //设置不显示
  _isShowTeamers = FALSE;
  [self membersViewDownToUp];
}

- (IBAction)showTeamerAction:(id)sender{
  [MobClick event:@"2013022511"];
  [self doAnimate:sender];
  [self removeAllAnnotations];
  //设置显示所有队友
  _isShowTeamers = TRUE;
  [self membersViewUpToDown];
  [self sendMyLocationQuartz];
}


- (void)doAnimate:(id)sender{
  
  [UIView animateWithDuration:0.3 animations:^{
    
    self.btnBgView.frame=((UIView*)sender).frame;
  }];
}
#pragma mark -
#pragma mark takePhotoActionSheet
- (void)showActionSheet {

  UIActionSheet *actionSheet=nil;
  if(![_ridding isEnd]){
    actionSheet= [[UIActionSheet alloc] initWithTitle:@"您希望从哪里选择照片?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍摄新照片" otherButtonTitles:@"从照片库选择", nil];
  }else{
    actionSheet= [[UIActionSheet alloc] initWithTitle:@"您希望从哪里选择照片?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从照片库选择" otherButtonTitles:nil, nil];
  }
  actionSheet.delegate = self;
  [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  [imagePicker setDelegate:self];
  if (buttonIndex == 0) {
    [MobClick event:@"2012111904"];
    _isFromCamera = YES;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
  } else if (buttonIndex == 1) {
    _isFromCamera = NO;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
  } else {
    return;
  }
  [self presentModalViewController:imagePicker animated:YES];
  return;

}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {

  [actionSheet setHidden:YES];
  [actionSheet removeFromSuperview];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  // 保存拍照
  if(_isFromCamera) {
    UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage], nil, nil, nil);
  }
  
  dispatch_queue_t q;
  q = dispatch_queue_create("didFinishPickingMediaWithInfo", NULL);
  dispatch_async(q, ^{
    UIImage *newImage =[info objectForKey:UIImagePickerControllerOriginalImage];
    if(!newImage.imageOrientation==UIImageOrientationDown&&!newImage.imageOrientation==UIImageOrientationUp){
      newImage=[Utilities imageWithImage:newImage scaledToSize:newImage.size];
    }
    CGFloat width;
    CGFloat height;
    if (newImage.imageOrientation == UIImageOrientationLeft || newImage.imageOrientation == UIImageOrientationRight) {
      width = CGImageGetHeight([newImage CGImage]);
      height = CGImageGetWidth([newImage CGImage]);
    } else {
      width = CGImageGetWidth([newImage CGImage]);
      height = CGImageGetHeight([newImage CGImage]);
    }
    QQNRServerTask *task = [[QQNRServerTask alloc] init];
    task.step = STEP_UPLOADPHOTO;
    RiddingPicture *picture = [[RiddingPicture alloc] initWithRidding:(int) width height:(int) height ridding:_ridding];;
    [picture saveImageToLocal:newImage];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:picture, kFileClientServerUpload_RiddingPicture, nil];
    task.paramDic = dic;
    QQNRServerTaskQueue *queue = [QQNRServerTaskQueue sharedQueue];
    [queue addTask:task withDependency:NO];

    dispatch_async(dispatch_get_main_queue(), ^{
      [picker dismissModalViewControllerAnimated:NO];
      PhotoDescViewController *descVCTL = [[PhotoDescViewController alloc] initWithNibName:@"PhotoDescViewController" bundle:nil riddingPicture:picture isSyncSina:[_ridding syncSina] riddingName:_ridding.riddingName];
      [self presentModalViewController:descVCTL animated:NO];
    });
    
  });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

  [picker dismissModalViewControllerAnimated:YES];
}

- (void) video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
}
@end
