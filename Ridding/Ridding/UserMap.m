//
//  UserMap.m
//  Ridding
//
//  Created by zys on 12-3-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserMap.h"
#import "UIColor+XMin.h"
#import "CalloutMapAnnotationView.h"
#import "PhotoAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "SWSnapshotStackView.h"
#import "QQNRFeedViewController.h"
#import "PhotoDescViewController.h"
#import "RiddingLocation.h"
#import "MapUtil.h"
#import "StartAnnotation.h"
#import "EndAnnotation.h"
#import "InvitationViewController.h"
#import "QQNRServerTaskQueue.h"
#import "SVProgressHUD.h"
#import "QiNiuUtils.h"
#import "QQNRImagesScrollVCTL.h"

@interface UserMap ()
- (void)reductViewClick:(UITapGestureRecognizer *)gestureRecognize;

@end

@implementation UserMap
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _staticInfo=[StaticInfo getSinglton];
    
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (id)initWithUser:(User*)toUser ridding:(Ridding*)ridding{
  self=[super init];
  if(self){
    _toUser=toUser;
    _ridding=ridding;
  }
  return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.routes=[[NSMutableArray alloc]init];
  self.hasLeftView=FALSE;
  _isMyRidding=FALSE;
  if([StaticInfo getSinglton].user.userId==_toUser.userId){
    _isMyRidding=TRUE;
  }
  if(_isMyRidding){
    [self showSwitch];
    [self myLocationQuartz];
    [self goToDestinationQuartz];
    [self initAwesomeView];
    //兼容ip5
    self.zoomInButton.frame=CGRectMake(self.zoomInButton.frame.origin.x, SCREEN_HEIGHT-(460-self.zoomInButton.frame.origin.y), self.zoomInButton.frame.size.width, self.zoomInButton.frame.size.height);
    self.zoomOutButton.frame=CGRectMake(self.zoomOutButton.frame.origin.x, SCREEN_HEIGHT-(460-self.zoomOutButton.frame.origin.y), self.zoomOutButton.frame.size.width, self.zoomOutButton.frame.size.height);
    self.showLocationButton.frame=CGRectMake(self.showLocationButton.frame.origin.x, SCREEN_HEIGHT-(460-self.showLocationButton.frame.origin.y), self.showLocationButton.frame.size.width, self.showLocationButton.frame.size.height);
    [self.distanceSpeedView setHidden:NO];
  }
  UITapGestureRecognizer *viewTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapViewClick:)]; //动态添加点击操作
  [self.mapView addGestureRecognizer:viewTap];
  _isUserTapViewOut=FALSE;
  _isAnimationing=FALSE;
  _routesInited=FALSE;
  _isShowTeamers = FALSE;
  _userInited=FALSE;
  
  _photoArray=[[NSMutableArray alloc]init];
  self.userScrollView.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMFILE(@"hy_beijing", @"jpg")];
}

- (void)viewWillAppear:(BOOL)animated {
  [_sendMyLocationTimer fire];
  [_getToDestinationTimer fire];
  [super viewWillAppear:animated];
  dispatch_async(dispatch_queue_create("download", NULL), ^{
    dispatch_async(dispatch_get_main_queue(), ^{
      [self download];
    });
  });
}

- (void)showSwitch{
  if(!_redSC){
    _redSC= [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"队友", @"单人", @"照片", nil]];
    [_redSC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    _redSC.crossFadeLabelsOnDrag = YES;
    _redSC.thumb.tintColor = [UIColor getColor:ColorBlue];
    _redSC.selectedIndex = 1;
    [self.view addSubview:_redSC];
    _redSC.center = CGPointMake(120, 20);
  }
}

-(void)download{
  if(!loadingView){
    loadingView=[[ActivityView alloc]init:@"初始化数据中" lat:self.view.frame.size.width/2 log:self.view.frame.size.height/2];
    [self.view addSubview:loadingView];
  }
  if(!_userInited&&_isMyRidding){
    [loadingView setHidden:NO];
    //异步去加载用户
    [self removeAllUserView];
    [self setUsers];
  }else{
    _userInited=TRUE;
  }
  if(!_routesInited){
    [loadingView setHidden:NO];
    //异步去画地图
    [self drawRoutes];
  }
}

- (void)viewWillDisappear:(BOOL)animated{
  [_sendMyLocationTimer invalidate];
  [_getToDestinationTimer invalidate];
  [super viewWillDisappear:animated];
}

//得到我离终点的距离
-(void)getToDestinationDistance{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSArray *array=[[RiddingLocationDao getSinglton] getRiddingLocations:_ridding.riddingId beginWeight:0];
    if(!array||[array count]==0){
      return;
    }
    QQNRMyLocation *myLocation=[[RiddingAppDelegate shareDelegate]myLocation];
    CLLocationDistance nearestLength=-1;
    int index=0;
    for(int i=0;i<[array count];i++){
      RiddingLocation* location=(RiddingLocation*)[array objectAtIndex:i];
      CLLocation *aLocation=[[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longtitude];
      CLLocationDistance kilometers=[aLocation distanceFromLocation:myLocation.location]/1000;
      if(kilometers < nearestLength||nearestLength==-1){
        nearestLength=kilometers;
        index=i;
      }
    }
    for(int i=index;i<[array count];i++){
      RiddingLocation* location=(RiddingLocation*)[array objectAtIndex:i];
      nearestLength+=location.toNextDistance;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.toDistanceLabel setText:[NSString stringWithFormat:@"还有距离:%0.2lf km",nearestLength/1000]];
    });
    
  });
}

-(void)setUsers{
  dispatch_queue_t q;
  q=dispatch_queue_create("setUsers", NULL);
  dispatch_async(q, ^{
    NSArray *array = [self.requestUtil getUserList:_ridding.riddingId];
    if(array&&[array count]>0){
      for(NSDictionary *dic in array){
        User *user=[[User alloc]initWithJSONDic:[dic objectForKey:@"user"]];
        if(_staticInfo.user.userId==user.userId){
          if([Ridding isLeader:user.userRole]){
            _staticInfo.user.isLeader=TRUE;
          }else{
            _staticInfo.user.isLeader=FALSE;
          }
        }
        [self.userArray addObject:user];
      }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [self setUserScrollView];
      _userInited=TRUE;
      if(_routesInited&&_userInited){
        [loadingView setHidden:YES];
      }
    });
  });
}

//定时发送我的当前位置
-(void)sendMyLocationQuartz{
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
  [delegate startUpdateMyLocation];
  [delegate startUpdateMyLocationHeading];
  dispatch_queue_t q;
  q=dispatch_queue_create("sendMyLocationQuartz", NULL);
  dispatch_async(q, ^{
    MKCoordinateRegion theRegion;
    theRegion.center = [delegate myLocation].location.coordinate;
    CLLocationDegrees latitude=theRegion.center.latitude;
    CLLocationDegrees longtitude=theRegion.center.longitude;
    double speed=0.0;
    [self.requestUtil sendAndGetAnnotation:_ridding.riddingId latitude:latitude longtitude:longtitude status:1 speed:speed isGetUsers:_isShowTeamers?1:0];
  });
}

//画路线
-(void)drawRoutes{
  dispatch_queue_t q;
  q=dispatch_queue_create("drawRoutes", NULL);
  dispatch_async(q, ^{
    _line_color = [UIColor getColor:lineColor];
    NSArray *routeArray=[[RiddingLocationDao getSinglton] getRiddingLocations:_ridding.riddingId beginWeight:0];
    int totalDistance=0;
    if([routeArray count]>0){
      for(RiddingLocation *location in routeArray){
        totalDistance+=location.toNextDistance;
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longtitude];
        [self.routes addObject:loc];
      }
    }else{
      //如果数据库中存在，那么取数据库中的地图路径，如果不存在，http去请求服务器。
      //数据库中取出是mapTaps或者points
      NSMutableDictionary *map_dic = [self.requestUtil getMapMessage:_ridding.riddingId userId:_staticInfo.user.userId];
      Map *map=[[Map alloc]initWithJSONDic:[map_dic objectForKey:@"map"]];
      NSArray *array = map.mapPoint;
      [[MapUtil getSinglton]calculate_routes_from:map.mapTaps map:map];
      self.routes = [[MapUtil getSinglton] decodePolyLineArray:array];
      totalDistance=map.distance;
      [[RiddingLocationDao getSinglton] setRiddingLocationToDB:map riddingId:_ridding.riddingId];
    }
    float dis = totalDistance*1.0/1000;
    dispatch_async(dispatch_get_main_queue(), ^{
      if(self){
         self.distanceLabel.text = [NSString stringWithFormat:@"总距离:%0.2lf km",dis];
        [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:_line_color routes:self.routes];
        [[MapUtil getSinglton] center_map:self.mapView routes:self.routes];
        CLLocation* startLocation=[self.routes objectAtIndex:0];
        [self addStartAnnotationWithcoordinateX:startLocation.coordinate.latitude coordinateY:startLocation.coordinate.longitude Title:@"title1" Subtitle:@"subtitle1"];
        CLLocation* endLocation=[self.routes objectAtIndex:[self.routes count]-1];
        [self addEndAnnotationWithcoordinateX:endLocation.coordinate.latitude coordinateY:endLocation.coordinate.longitude Title:@"title2" Subtitle:@"subtitle2"];
        _routesInited=YES;
        if(_routesInited&&_userInited){
          [loadingView setHidden:YES];
        }
      }
    });
  });
}

-(void)myLocationQuartz{
  NSTimeInterval time=[[NSString stringWithFormat:@"%@",sendMyLocationTime]doubleValue];
  _sendMyLocationTimer=[NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(sendMyLocationQuartz) userInfo:nil repeats:YES];
  [_sendMyLocationTimer fire];
}

-(void)goToDestinationQuartz{
  double time=[[NSString stringWithFormat:@"%@",getToDestinationTime]doubleValue];
  _getToDestinationTimer=[NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(getToDestinationDistance) userInfo:nil repeats:YES];
  [_getToDestinationTimer fire];
}

-(void) addStartAnnotationWithcoordinateX:(double)coorX coordinateY:(double)coorY
                                    Title:(NSString*)title Subtitle:(NSString*)subtitle{
  CLLocationCoordinate2D startPoint;
  if(coorX && coorY){
    startPoint.latitude = coorX;
    startPoint.longitude = coorY;
    StartAnnotation *_startAnnotation = [[StartAnnotation alloc] initWithCoords:startPoint];
    
    if(title!=NULL)
      _startAnnotation.title = title;
    if(subtitle!=NULL)
      _startAnnotation.subtitle = subtitle;
    [self.mapView addAnnotation:_startAnnotation];
  }
}
-(void) addEndAnnotationWithcoordinateX:(double)coorX coordinateY:(double)coorY
                                  Title:(NSString*)title Subtitle:(NSString*)subtitle{
  CLLocationCoordinate2D endPoint;
  if(coorX && coorY){
    endPoint.latitude = coorX;
    endPoint.longitude = coorY;
    EndAnnotation *_endAnnotation = [[EndAnnotation alloc] initWithCoords:endPoint];
    if(title!=NULL)
      _endAnnotation.title = title;
    if(subtitle!=NULL)
      _endAnnotation.subtitle = subtitle;
    [self.mapView addAnnotation:_endAnnotation];
  }
}

//插入用户位置的异步回调
#pragma requestUtil delegate
-(void)asyncReturnDic:(NSDictionary*)dic{
  NSArray *userArray=[dic objectForKey:@"users"];
  if(dic==nil||self.userArray==nil){
    return;
  }
  NSMutableDictionary *mulDic=[[NSMutableDictionary alloc]init];
  for(NSDictionary *location in userArray){
    User *user=[[User alloc]initWithJSONDic:location];
    [mulDic setObject:user forKey:LONGLONG2NUM(user.userId)];
  }
  NSMutableDictionary* annotationDic=[[NSMutableDictionary alloc]init];
  NSArray* annotations=[self.mapView annotations];
  if(annotations&&[annotations count]>0){
    for(id<MKAnnotation> annotation in annotations){
      if ([annotation isKindOfClass:[UserAnnotation class]]){
        UserAnnotation* userAnnotation=(UserAnnotation*)annotation;
        [annotationDic setObject:userAnnotation forKey:LONGLONG2NUM(userAnnotation.userId)];
      }
    }
  }
  dispatch_queue_t q;
  q=dispatch_queue_create("updateAnnotations", NULL);
  for (User *user in self.userArray) {
    //如果是当前用户
    if(user.userId==_staticInfo.user.userId){
      continue;
    }
    dispatch_async(q, ^{
      
      User *serverUser=[mulDic objectForKey:[NSString stringWithFormat:@"%lld",user.userId]];
      if (serverUser!=nil) {
        CLLocationDegrees latitude=serverUser.latitude;
        CLLocationDegrees longtitude=serverUser.longtitude;
        CLLocationCoordinate2D coordinate2D=CLLocationCoordinate2DMake(latitude, longtitude);
        user.speed=serverUser.speed;
        user.status=serverUser.status;
        UserAnnotation* userAnnotation=[annotationDic objectForKey:LONGLONG2NUM(user.userId)];
        if(!userAnnotation){
          userAnnotation=[[UserAnnotation alloc]init];
          userAnnotation.userId=user.userId;
          dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotation:userAnnotation];
          });
        }
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:user.savatorUrl]];
        userAnnotation.headImage=[UIImage imageWithData:imageData];
        userAnnotation.coordinate=coordinate2D;
        userAnnotation.subtitle=[NSString stringWithFormat:@"更新时间:%@",serverUser.timeBefore];
        userAnnotation.title = user.name;
        user.annotation=userAnnotation;
      }
    });
  }
  _onlineUserCount=0;
  for(UIView *view in [self.userScrollView subviews]){
    if([view isKindOfClass:[UserView class]]){
      UserView *userView=(UserView*)view;
      User *user=[mulDic objectForKey:LONGLONG2NUM(userView.user.userId)];
      userView.user.latitude=user.latitude;
      userView.user.longtitude=user.longtitude;
      [userView changeStatus:user.status];
      if(user.status==1){
        _onlineUserCount++;
      }
    }
  }
  self.userOnlineLabel.text=[NSString stringWithFormat:@"在线人数:%d/%d",_onlineUserCount,[self.userArray count]];
}

-(void)updatePhotoAnnotation{
  [SVProgressHUD show];
  dispatch_async(dispatch_queue_create("updatePhotoAnnotation", NULL), ^{
    [_photoArray removeAllObjects];
    NSArray *serverArray=[self.requestUtil getUploadedPhoto:_ridding.riddingId limit:-1 lastUpdateTime:-1];
    dispatch_async(dispatch_get_main_queue(), ^{
      if([serverArray count]>0){
        int index=0;
        for(NSDictionary *dic in serverArray){
          NSLog(@"%@",dic);
          RiddingPicture *picture=[[RiddingPicture alloc]initWithJSONDic:[dic objectForKey:@"picture"]];
          if(picture){
            CLLocationDegrees latitude=picture.latitude;
            CLLocationDegrees longtitude=picture.longtitude;
            PhotoAnnotation *photoAnnotation=[[PhotoAnnotation alloc]initWithLatitude:latitude andLongitude:longtitude];
            NSURL *url=[QiNiuUtils getUrlBySizeToUrl:CGSizeMake(50, 50) url:picture.photoUrl type:QINIUMODE_DESHORT];
            NSData *imageData=[NSData dataWithContentsOfURL:url];
            photoAnnotation.image= [UIImage imageWithData:imageData];
            photoAnnotation.index=index++;
            [self.mapView addAnnotation:photoAnnotation];
            [_photoArray addObject:picture];
            index++;
          }
        }
      }
      [SVProgressHUD dismiss];
    });
  });
}

-(void)removeAllAnnotations{
  if(self.mapView){
    NSArray* annotations=[self.mapView annotations];
    if(annotations&&[annotations count]>0){
      for(id<MKAnnotation> annotation in annotations){
        if (![annotation isKindOfClass:[MKUserLocation class]]&&![annotation isKindOfClass:[StartAnnotation class]]&&![annotation isKindOfClass:[EndAnnotation class]]){
          [self.mapView removeAnnotation:annotation];
        }
      }
    }
  }
}

-(void)removeAllCalloutAnnotations{
  if(self.mapView){
    NSArray* annotations=[self.mapView annotations];
    if(annotations&&[annotations count]>0){
      for(id<MKAnnotation> annotation in annotations){
        if ([annotation isKindOfClass:[CalloutMapAnnotation class]]){
          [self.mapView removeAnnotation:annotation];
        }
      }
    }
  }
}

//-(void)deselectAllAnnotations{
//  if(self.mapView){
//    NSArray* annotations=[self.mapView annotations];
//    if(annotations&&[annotations count]>0){
//      for(id<MKAnnotation> annotation in annotations){
//        if (![annotation isKindOfClass:[MKUserLocation class]]&&![annotation isKindOfClass:[StartAnnotation class]]&&![annotation isKindOfClass:[EndAnnotation class]]){
//          [self.mapView deselectAnnotation:annotation animated:YES];
//        }
//      }
//    }
//  }
//}

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
-(void) myAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
  _isAnimationing=FALSE;
}

/**
 **(begin)
 **userScrollView相关模块
 **/
//插入用户滚动view
-(void)setUserScrollView{
  isShowDelete=FALSE;
  int width=80;
  int height=80;
  int index=1;
  int addViewCount=1;
  //如果不是队长是成员
  if(!_staticInfo.user.isLeader||_ridding.riddingStatus==20){
    addViewCount=0;
    index=0;
  }
  UIImageView *imageView=[[UIImageView alloc]init];
  [imageView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
  [self.userScrollView addSubview:imageView];
  if(self.userArray&&[self.userArray count]>4){
    [imageView setFrame:CGRectMake(0, 0, width*([self.userArray count]+addViewCount), self.userScrollView.frame.size.height)];
  }
  UIView *outActionView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
  outActionView.userInteractionEnabled=YES;
  UITapGestureRecognizer *viewTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionViewClick:)];
  [outActionView addGestureRecognizer:viewTap];
  if(_staticInfo.user.isLeader&&_ridding.riddingStatus!=20){
    UIImageView *actionview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 60, 60)];
    UIImage *image=[UIImage imageNamed:@"addUser.png"];
    actionview.image=image;
    [outActionView addSubview:actionview];
  }
  [self.userScrollView addSubview:outActionView];
  self.userScrollView.contentSize = CGSizeMake(width, height);
  self.userScrollView.bounces=YES;
  if (self.userArray&&[self.userArray count]>0) {
    for (User *user in self.userArray) {
      UserView *userView=[[UserView alloc]initWithFrame:CGRectMake(5+(width)*(index++), 0, width, height)];
      userView.user=user;
      userView.delegate=self;
      userView=[userView init];
      userView.backgroundColor = [UIColor clearColor];
      if(_staticInfo.user.isLeader){
        UILongPressGestureRecognizer *longTap =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longViewClick:)];
        [userView addGestureRecognizer:longTap];
        userView.userInteractionEnabled=YES;
      }

      [self.userScrollView addSubview:userView];
    }
    self.userScrollView.contentSize = CGSizeMake((width)*([self.userArray count]+addViewCount), height);
  }
  
  
}
#pragma mark - Animation for Member Views
//点击地图后，scrollview隐藏显示的信息操作
-(void)mapViewClick:(UITapGestureRecognizer*) gestureRecognize{
  if (_isUserTapViewOut==TRUE) {
    [self membersViewUpToDown];
    _isUserTapViewOut=FALSE;
    NSArray *array=[self.userScrollView subviews];
    if(array&&[array count]>0){
      for(UIView *view in array){
        if([view isKindOfClass:[UserView class]]){
          UserView *userView=(UserView*)view;
          [userView hideDeleteBtn];
        }
      }
    }
    isShowDelete=FALSE;
  }
  [self removeAllCalloutAnnotations];
}




#pragma mark - UserScrollView animate
//长按
-(void)longViewClick:(UITapGestureRecognizer*)gestureRecognize{
  isShowDelete=TRUE;
  NSArray *array=[self.userScrollView subviews];
  if(array&&[array count]>0){
    for(UIView *view in array){
      if([view isKindOfClass:[UserView class]]){
        UserView *userView=(UserView*)view;
        [userView showDeleteBtn];
      }
    }
  }
}

#pragma UserView Delegate
-(void)deleteBtnClick:(UserView*)userView{
  [MobClick event:@"2012070205"];
  CGFloat x=userView.frame.origin.x;
  [self.requestUtil deleteRiddingUser:_ridding.riddingId deleteUserIds:[[NSArray alloc]initWithObjects:LONGLONG2NUM(userView.user.userId), nil]];
  
  if(self.userScrollView){
    [userView removeFromSuperview];
    [self.userScrollView setContentSize:CGSizeMake(self.userScrollView.contentSize.width-userView.frame.size.width, userView.frame.size.height)];
    NSArray* userViews=[self.userScrollView subviews];
    for(UIView *view in userViews){
      if(view.frame.origin.x>x){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        [UIView setAnimationDelegate:self];
        [view setFrame:CGRectMake(view.frame.origin.x-view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
        [UIView commitAnimations];
      }
    }
  }
  
  if(self.userArray&&[self.userArray count]>0){
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    for (User *user in self.userArray) {
      if(user.userId!=userView.user.userId){
        [tempArray addObject:user];
      }
    }
    self.userArray=tempArray;
  }
  self.userOnlineLabel.text=[NSString stringWithFormat:@"在线人数:%d/%d",_onlineUserCount,[self.userArray count]];
}

-(void)avatorBtnClick:(UserView*)userView{
  if(userView.user.userId==_staticInfo.user.userId){
    return;
  }
  if(self.userArray){
    for(User *user in self.userArray){
      if(userView.user.userId==user.userId){
        MKCoordinateRegion region;
        region.center.latitude=userView.user.latitude;
        region.center.longitude=userView.user.longtitude;
        region.span=self.mapView.region.span;
        [self.mapView setRegion:region animated:YES];
        [self.mapView selectAnnotation:user.annotation animated:YES];
        break;
      }
    }
  }
}

-(void)actionViewClick:(UITapGestureRecognizer*) gestureRecognize{
  [MobClick event:@"2012070203"];
  _userInited=FALSE;
  InvitationViewController* invitationView=[[InvitationViewController alloc]initWithNibName:@"InvitationViewController" bundle:nil riddingId:_ridding.riddingId nowTeamers:self.userArray];
  [self.navigationController pushViewController:invitationView animated:YES];
  [self membersViewUpToDown];
}

-(void)membersViewDownToUp
{
  if(!_userInited||!_routesInited){
    return;
  }
  if(self.userScrollView.frame.origin.y!=SCREEN_HEIGHT){
    return;
  }
  _isAnimationing = YES;
  [_menu setHidden:YES];
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3f];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(myAnimationDidStop:finished:context:)];
  [self.userScrollView setFrame:CGRectMake(0, SCREEN_HEIGHT-self.userScrollView.frame.size.height, self.view.frame.size.width, self.userScrollView.frame.size.height)];
  [UIView commitAnimations];
  if(_isShowTeamers){
    self.userOnlineLabel.hidden=NO;
  }
  
  _isUserTapViewOut=TRUE;
}
-(void)membersViewUpToDown{
  if(self.userScrollView.frame.origin.y==SCREEN_HEIGHT){
    return;
  }
  self.userOnlineLabel.hidden=YES;
  _isAnimationing = YES;
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3f];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(myAnimationDidStop:finished:context:)];
  [self.userScrollView setFrame:CGRectMake(0, SCREEN_HEIGHT, self.userScrollView.frame.size.width, self.userScrollView.frame.size.height)];
  [UIView commitAnimations];
  [_menu setHidden:NO];
  _isUserTapViewOut=FALSE;
}

-(void)removeAllUserView{
  if(self&&self.userScrollView&&[self.userScrollView.subviews count]>0){
    NSArray *array=[self.userScrollView subviews];
    for(UIView *view in array){
      [view removeFromSuperview];
    }
  }
  [self removeAllAnnotations];
  self.userArray=[[NSMutableArray alloc]init];
}


#pragma mark CLLocationManager Heading Delegate
- (void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)newHeading{
  if (newHeading.headingAccuracy > 0){
    CGFloat heading = (1.0f*M_PI*newHeading.trueHeading)/180.f;
    myLocationAnnotationView.transform = CGAffineTransformMakeRotation(heading);
  }
}

#pragma mark mapView delegate functions

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
  self.route_view.hidden = YES;
}
//地图移动结束后的操作
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:_line_color routes:self.routes];
  self.route_view.hidden = NO;
  [self.route_view setNeedsDisplay];
}
//选中某个annotation时
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
  //添加点击弹出图
  if([view.annotation isKindOfClass:[PhotoAnnotation class]]){
    [self removeAllCalloutAnnotations];
    PhotoAnnotation *photoAnnotation=(PhotoAnnotation*)view.annotation;
    CLLocationCoordinate2D location=photoAnnotation.coordinate;
    CalloutMapAnnotation *annotation=[[CalloutMapAnnotation alloc]initWithLatitude:location.latitude andLongitude:location.longitude];
    annotation.index=photoAnnotation.index;
    _showingImage=photoAnnotation.image;
    [self.mapView addAnnotation:annotation];
    _showingAnnotationView=view;
  }
}

//取消选中某个annotation时
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
  if ([view.annotation isKindOfClass:[CalloutMapAnnotation class]]) {
		[self.mapView removeAnnotation: view.annotation];
	}
}
//在addAnnotation的时候调用
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
  
  if ([annotation isKindOfClass:[MKUserLocation class]]){
    return nil;
  }
  if ([annotation isKindOfClass:[StartAnnotation class]]) {
    MKAnnotationView *newAnnotation=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationStart"];
    newAnnotation.image = [UIImage imageNamed:@"起点.png"];
    newAnnotation.canShowCallout = NO;
    return newAnnotation;
  }
  
  if ([annotation isKindOfClass:[EndAnnotation class]]) {
    MKAnnotationView *newAnnotation=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationEnd"];
    newAnnotation.image = [UIImage imageNamed:@"终点.png"];
    newAnnotation.canShowCallout = NO;
    return newAnnotation;
  }
  
  // 处理我们自定义的Annotation
  if ([annotation isKindOfClass:[UserAnnotation class]]) {
      MKAnnotationView* customPinView = [[MKAnnotationView alloc]
                                         initWithAnnotation:annotation reuseIdentifier:@"UserAnnotationIdentifier"];
      
      [customPinView setCanShowCallout:YES]; //很重要，运行点击弹出标签
      customPinView.draggable=NO;
      UserAnnotation *userAnnotation = (UserAnnotation *)annotation;
      UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
      headImage.image=userAnnotation.headImage;
      customPinView.leftCalloutAccessoryView = headImage; //设置最左边的头像
      
      UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
      [rightButton addTarget:self action:@selector(showDetails)  //点击右边的按钮之后，显示另外一个页面
            forControlEvents:UIControlEventTouchUpInside];
      
      customPinView.rightCalloutAccessoryView = rightButton;
      UIImage *image = [UIImage imageNamed:@"其他队友.png"];
      customPinView.image = image;
      customPinView.opaque = YES;
      return customPinView;
  }
  if([annotation isKindOfClass:[PhotoAnnotation class]]){
    static NSString* travellerAnnotationIdentifier = @"PhotoAnnotationIdentifier";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:travellerAnnotationIdentifier];
    if (!pinView)
    {
      pinView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"PhotoAnnotationIdentifier"];
    }else
    {
      pinView.annotation = annotation;
    }
    return pinView;
  }
  if([annotation isKindOfClass:[CalloutMapAnnotation class]]){
    CalloutMapAnnotationView *calloutMapAnnotationView = [[CalloutMapAnnotationView alloc] initWithAnnotation:annotation
                                                                                              reuseIdentifier:@"CalloutAnnotation"];
    calloutMapAnnotationView.contentHeight = 90.0f;
    calloutMapAnnotationView.userInteractionEnabled=YES;
    CalloutMapAnnotation *callOutAnnotation=(CalloutMapAnnotation*)annotation;
    calloutMapAnnotationView.index=callOutAnnotation.index;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    [calloutMapAnnotationView addGestureRecognizer:tap];
    CGFloat width=90;
    CGFloat height=width/CGImageGetWidth([_showingImage CGImage])*CGImageGetHeight([_showingImage CGImage]);
    SWSnapshotStackView *stackView=[[SWSnapshotStackView alloc]initWithFrame:CGRectMake(5, 2, width, height)];
    stackView.contentMode=UIViewContentModeRedraw;
    stackView.displayAsStack = NO;
    stackView.image=_showingImage;
    [calloutMapAnnotationView.contentView addSubview:stackView];
		calloutMapAnnotationView.parentAnnotationView = _showingAnnotationView;
		calloutMapAnnotationView.mapView = self.mapView;
		return calloutMapAnnotationView;
  }
  return nil;
}

- (void)showDetails {
  //显示用户详情,annotationview
}

- (void)photoViewTap:(UIGestureRecognizer*)gesture{
  CalloutMapAnnotationView *view=(CalloutMapAnnotationView*)gesture.view;
  QQNRImagesScrollVCTL *vctl = [[QQNRImagesScrollVCTL alloc] initWithNibName:@"QQNRImagesScrollVCTL" bundle:nil startPageIndex:view.index];
	vctl.photoArray = _photoArray;
	[self.navigationController pushViewController:vctl animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Button Responser IBAction
-(IBAction)backBtnClick:(id)sender{
  if(self){
    [self.navigationController popViewControllerAnimated:YES];
  }
}

-(IBAction)showLocationButtonClicked:(id)sender
{
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
  if(![delegate canGetLocation]){
    [_sendMyLocationTimer invalidate];
    return;
  }
  if(![_sendMyLocationTimer isValid]){
    [_sendMyLocationTimer fire];
  }
  MKCoordinateRegion region;
  region.center=[self.mapView userLocation].coordinate;
  region.span=self.mapView.region.span;
  [self.mapView setRegion:region animated:YES];
}

-(IBAction)zoomInButtonClicked:(id)sender
{
  [MobClick event:@"2012070202"];
  if(_zooming){
    return;
  }
  MKCoordinateRegion region = self.mapView.region;
  region.span.latitudeDelta=region.span.latitudeDelta / 2;
  region.span.longitudeDelta=region.span.longitudeDelta / 2;
  if(region.span.latitudeDelta>0&&region.span.longitudeDelta>0){
    [self.mapView setRegion:region animated:YES];
  }
  _zooming=false;
  
}
-(IBAction)zoomOutButtonClicked:(id)sender
{
  [MobClick event:@"2012070201"];
  MKCoordinateRegion region = self.mapView.region;
  region.span.latitudeDelta=region.span.latitudeDelta * 2;
  region.span.longitudeDelta=region.span.longitudeDelta * 2;
  if(_zooming||region.span.latitudeDelta>200){
    return;
  }
  _zooming=true;
  [self.mapView setRegion:region animated:YES];
  _zooming=false;
}


- (void)initAwesomeView{
  UIImage *storyMenuItemImage =UIIMAGE_FROMPNG(@"bg-menuitem");
  UIImage *storyMenuItemImagePressed = UIIMAGE_FROMPNG(@"bg-menuitem-highlighted");
  
  UIImage *showUser;
  if(_isShowTeamers){
    showUser=UIIMAGE_FROMPNG(@"showSingleUser");
  }else{
    showUser=UIIMAGE_FROMPNG(@"showMultipleUsers");
  }
  
  UIImage *takePhotoImg=UIIMAGE_FROMPNG(@"btn_fabu");
  AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                         highlightedImage:storyMenuItemImagePressed
                                                             ContentImage:showUser
                                                  highlightedContentImage:nil];
  AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                         highlightedImage:storyMenuItemImagePressed
                                                             ContentImage:takePhotoImg
                                                  highlightedContentImage:nil];
  
  
  NSArray *menus = [NSArray arrayWithObjects:starMenuItem2, starMenuItem3, nil];
  
  
  _menu = [[AwesomeMenu alloc] initWithFrame:CGRectMake(-130, 170, 38, 38) menus:menus];
    _menu.frame=CGRectMake(_menu.frame.origin.x, SCREEN_HEIGHT-(460-_menu.frame.origin.y), _menu.frame.size.width, _menu.frame.size.height);
	// customize menu
	_menu.rotateAngle = M_PI/5.0;
	_menu.menuWholeAngle = M_PI/2.5;
	_menu.timeOffset = 0.1f;
	_menu.farRadius = 200.0f;
	_menu.endRadius = 150.0f;
	_menu.nearRadius = 50.0f;
  _menu.delegate = self;
  [self.view addSubview:_menu];
  
}

- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
  switch (idx) {
    case 0:
    {
      [_redSC moveThumbToIndex:0 animate:YES];
      [self membersViewDownToUp];
    }
    break;
    case 1:
    {
      [self showActionSheet];
    }
    break;
    default:
      DLog(@"error!");
      break;
  }
}


#pragma mark -
#pragma mark SPSegmentedControl
- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
  [self removeAllAnnotations];
  if(segmentedControl.selectedIndex==SHOWTEAMER){
    //设置显示所有队友
    _isShowTeamers=TRUE;
    [self membersViewDownToUp];
    [self sendMyLocationQuartz];
    
  }else if(segmentedControl.selectedIndex==SHOWSELF){
    //设置不显示
    _isShowTeamers=FALSE;
    [self membersViewUpToDown];
  }else{
    _isShowTeamers=FALSE;
    [self updatePhotoAnnotation];
    [self membersViewUpToDown];
  }
}

#pragma mark -
#pragma mark takePhotoActionSheet
- (void)showActionSheet{
  UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:@"选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"本地相册",nil];
  actionSheet.delegate=self;
  [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  [imagePicker setDelegate:self];
  if (buttonIndex==0) {
    [MobClick event:@"2012111904"];
    _isFromCamera=YES;
    imagePicker.videoQuality=UIImagePickerControllerQualityTypeLow;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
  }else if(buttonIndex==1){
    _isFromCamera = NO;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
  }else{
    return;
  }
  [self presentModalViewController:imagePicker animated:YES];
  return;
  
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
  [actionSheet setHidden:YES];
  [actionSheet removeFromSuperview];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  CGFloat width;
  CGFloat height;
  if(newImage.imageOrientation==UIImageOrientationLeft||newImage.imageOrientation==UIImageOrientationRight){
    width=CGImageGetHeight([newImage CGImage]);
    height=CGImageGetWidth([newImage CGImage]);
  }else{
    width=CGImageGetWidth([newImage CGImage]);
    height=CGImageGetHeight([newImage CGImage]);
  }
  dispatch_queue_t q;
  q=dispatch_queue_create("didFinishPickingMediaWithInfo", NULL);
  dispatch_async(q, ^{
    QQNRServerTask *task=[[QQNRServerTask alloc]init];
    task.step=STEP_UPLOADPHOTO;
    RiddingPicture *picture = [self returnRiddingPicture:(int)width height:(int)height];
    picture.image=newImage;
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:picture,kFileClientServerUpload_RiddingPicture, nil];
    task.paramDic=dic;
    
    QQNRServerTaskQueue *queue=[QQNRServerTaskQueue sharedQueue];
    [queue addTask:task withDependency:NO];
   
    if(picture){
      dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissModalViewControllerAnimated:NO];
        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:picture,@"picture", nil];
        PhotoDescViewController *descVCTL=[[PhotoDescViewController alloc]initWithNibName:@"PhotoDescViewController" bundle:nil info:dic];
        [self presentModalViewController:descVCTL animated:NO];
      });
    }
  });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissModalViewControllerAnimated:YES];
}

- (RiddingPicture*)returnRiddingPicture:(int)width height:(int)height{
  RiddingPicture* picture=[[RiddingPicture alloc]init];
  picture.riddingId=_ridding.riddingId;
  picture.user=[StaticInfo getSinglton].user;
  
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
  [delegate startUpdateMyLocation];
  QQNRMyLocation *myLocation=[delegate myLocation];
  picture.latitude=myLocation.latitude;
  picture.longtitude=myLocation.longtitude;
  
  NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
  picture.takePicDateL=(long long)[date timeIntervalSince1970]*1000;
  picture.location=myLocation.city;
  picture.width=width;
  picture.height=height;
  return picture;
}

@end
