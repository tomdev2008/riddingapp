//
//  UserMap.m
//  Ridding
//
//  Created by zys on 12-3-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserMap.h"
#import "UIColor+XMin.h"
#import "ResponseCodeCheck.h"
#import "UserInfoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImageUtil.h"
#import "RiddingPictureDao.h"
#import "PhotoListViewController.h"
#import "AwesomeMenuItem.h"
#import <QuartzCore/QuartzCore.h>
#import "CalloutMapAnnotationView.h"
#import "Photos.h"
#import "PhotoAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "SWSnapshotStackView.h"
#import "KTPhotoScrollViewController.h"
#import "QQNRFeedViewController.h"
#import "PhotoDescViewController.h"
#import "PublicDetailViewController.h"
#import "UserView.h"
#import "RiddingLocation.h"
#import "RiddingLocationDao.h"
#import "MapUtil.h"
#import "StartAnnotation.h"
#import "EndAnnotation.h"
#import "MobClick.h"
#import "InvitationViewController.h"

@implementation UserMap
@synthesize mapView;
@synthesize route_view=_route_view;
@synthesize line_color;
@synthesize routes=_routes;
@synthesize requestUtil;

@synthesize userArray=_userArray;
@synthesize staticInfo;
@synthesize lastLocation;
@synthesize myLocation=_myLocation;
@synthesize coordinate;
@synthesize isShowDelete;
@synthesize loadingView;

@synthesize backBtn=_backBtn;
@synthesize distanceLabel=_distanceLabel;
@synthesize toDistanceLabel=_toDistanceLabel;
@synthesize distanceSpeedView=_distanceSpeedView;
@synthesize showLocationButton=_showLocationButton;
@synthesize zoomInButton=_zoomInButton;
@synthesize zoomOutButton=_zoomOutButton;
@synthesize userScrollView=_userScrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    requestUtil=[RequestUtil getSinglton];
    requestUtil.requestUtilDelegate=self;
    staticInfo=[StaticInfo getSinglton];
    self.myLocation = [[CLLocationManager alloc] init];
    [self.myLocation setDelegate:self];
    if ([CLLocationManager headingAvailable])
    {
      self.myLocation.headingFilter=5;
    }
    
    [self.myLocation setDesiredAccuracy:kCLLocationAccuracyBest];
    
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (id)initWithUser:(User*)nowUser info:(ActivityInfo *)info riddingStatus:(NSNumber *)riddingStatus{
  self=[super init];
  if(self){
    _nowUser=nowUser;
    _riddingId=[info.dbId stringValue];
    _info=info;
    _riddingStatus=riddingStatus;
  }
  return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  _isMyRidding=FALSE;
  if([[StaticInfo getSinglton].user.userId longLongValue]==[_nowUser.userId longLongValue]){
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
  
  self.userScrollView.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMFILE(@"hy_beijing", @"jpg")];
}

- (void)viewWillAppear:(BOOL)animated {
  self.myLocation.delegate=self;
  requestUtil.requestUtilDelegate=self;
  mapView.delegate=self;
  self.userScrollView.delegate=self;
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

- (void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)newHeading{
  if (newHeading.headingAccuracy > 0){
    CGFloat heading = (1.0f*M_PI*newHeading.trueHeading)/180.f;
    myLocationAnnotationView.transform = CGAffineTransformMakeRotation(heading);
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
  self.myLocation.delegate=nil;
  requestUtil.requestUtilDelegate=nil;
  mapView.delegate=nil;
  self.userScrollView.delegate=nil;
  [_sendMyLocationTimer invalidate];
  [_getToDestinationTimer invalidate];
  for (UIView* view in [self.userScrollView subviews]) {
    if([view isKindOfClass:[UserView class]]){
      UserView *userView=(UserView*)view;
      userView.userViewDelegate=nil;
    }
  }
  [super viewWillDisappear:animated];
}



//得到我离终点的距离
-(void)getToDestinationDistance{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSArray *array=[[RiddingLocationDao getSinglton] getRiddingLocations:_riddingId beginWeight:[NSNumber numberWithInt:0]];
    if(!array||[array count]==0){
      return;
    }
    CLLocation* checkLocation=self.myLocation.location;
    CLLocationDistance nearestLength=-1;
    RiddingLocation *nearestLocation=nil;
    int index=0;
    for(int i=0;i<[array count];i++){
      RiddingLocation* location=(RiddingLocation*)[array objectAtIndex:i];
      CLLocation *alocation=[[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longtitude];
      CLLocationDistance kilometers=[alocation distanceFromLocation:checkLocation]/1000;
      if(kilometers < nearestLength||nearestLength==-1){
        nearestLength=kilometers;
        nearestLocation=location;
        index=i;
      }
    }
    for(int i=index;i<[array count];i++){
      RiddingLocation* location=(RiddingLocation*)[array objectAtIndex:i];
      nearestLength+=[location.toNextDistance doubleValue];
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
    NSArray *array = [requestUtil getUserList:_riddingId];
    if(array&&[array count]>0){
      for(NSDictionary *auser in array){
        User *user=[[User alloc]init];
        user.userId = [auser objectForKey:@"userid"];
        user.userRole = [auser objectForKey:@"userRole"];
        user.name = [auser objectForKey:@"nickname"];
        staticInfo.user.isLeader=FALSE;
        if ([staticInfo.user.userId longLongValue]==[user.userId longLongValue]) {
          staticInfo.user.userRole = user.userRole;
          if([user.userRole intValue]==20){
               staticInfo.user.isLeader=TRUE;
          }
        }
        //如果是当前用户，不添加
        user.isLeader=FALSE;
        if([user.userRole intValue]==20){
          user.isLeader=TRUE;
        }
        if(![[auser objectForKey:@"bavatorUrl"] isEqualToString:@""]){
          user.bavatorUrl=[auser objectForKey:@"bavatorUrl"];
        }
        if(![[auser objectForKey:@"savatorUrl"] isEqualToString:@""]){
          user.savatorUrl=[auser objectForKey:@"savatorUrl"];
        }
        if(![[auser objectForKey:@"nickname"] isEqualToString:@""]){
          user.name=[auser objectForKey:@"nickname"];
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
  [self.myLocation startUpdatingLocation];
  [self.myLocation startUpdatingHeading];
  dispatch_queue_t q;
  q=dispatch_queue_create("sendMyLocationQuartz", NULL);
  dispatch_async(q, ^{
    MKCoordinateRegion theRegion;
    theRegion.center = [[self.myLocation location] coordinate];
    CLLocationDegrees latitude=theRegion.center.latitude;
    CLLocationDegrees longtitude=theRegion.center.longitude;
    double speed=[self getSpeed];
    [requestUtil sendAndGetAnnotation:_riddingId latitude:[NSString stringWithFormat:@"%lf",latitude] longtitude:[NSString stringWithFormat:@"%lf",longtitude] status:@"1" speend:speed isGetUsers:_isShowTeamers?1:0];
  });
}

//插入用户位置的异步回调
-(void)sendAndGetAnnotationReturn:(NSArray*)returnArray{
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  for(NSDictionary *location in returnArray){
    [dic setValue:location forKey:[[location objectForKey:@"userId"]stringValue]];
  }
  [self updateAnnotations:dic];
}

//得到当前速度
-(double)getSpeed{
  if(lastLocation==nil){
    lastLocation=[[CLLocation alloc]init];
    return 0;
  }
  CLLocation *nowLocation=[self.myLocation location];
  CLLocationDistance meters=[nowLocation distanceFromLocation:lastLocation];
  lastLocation=[nowLocation copy];
  return (meters*3.6)/([[NSString stringWithFormat:@"%@",getToDestinationTime]doubleValue]);
}
//画路线
-(void)drawRoutes{
  dispatch_queue_t q;
  q=dispatch_queue_create("drawRoutes", NULL);
  dispatch_async(q, ^{
    line_color = [UIColor getColor:lineColor];
    //如果数据库中存在，那么取数据库中的地图路径，如果不存在，http去请求服务器。
    //数据库中取出是mapTaps或者points
    NSMutableDictionary *map_dic = [[NSMutableDictionary alloc]init];
    map_dic = [requestUtil getMapMessage:_riddingId];
    NSArray *array = [map_dic objectForKey:@"points"];
    if (!array) {
      array = [map_dic objectForKey:@"mapTaps"];
      if(!array){
        [self.navigationController popViewControllerAnimated:YES];
      }
      //基本不会使用了 by zys 20120719
      [[MapUtil getSinglton] calculate_routes_from:array map_dic:map_dic];
      if(map_dic){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                        message:@"生成地图失败。"
                                                       delegate:self cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [self.navigationController popToRootViewControllerAnimated:YES];
      }
      array = [map_dic objectForKey:@"points"];
      [requestUtil sendMapPoiont:_riddingId point:array mapId:[map_dic objectForKey:@"id"] distance:[map_dic objectForKey:@"distance"]];
    }
    float dis = [[map_dic objectForKey:@"distance"] intValue]*1.0/1000;
    self.routes = [[MapUtil getSinglton] decodePolyLineArray:array];
    dispatch_async(dispatch_get_main_queue(), ^{
      if(self){
         self.distanceLabel.text = [NSString stringWithFormat:@"总距离:%0.2lf km",dis];
        [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:line_color routes:self.routes];
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
    [self setRiddingLocationToDB:map_dic];
  });
}

-(void)myLocationQuartz{
  MKCoordinateRegion region = self.mapView.region;
  region.span.latitudeDelta=10;
  region.span.longitudeDelta=10;
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

//插入骑行的经纬度等信息到数据库
-(void)setRiddingLocationToDB:(NSMutableDictionary*)map_dic{
  dispatch_queue_t q;
  q=dispatch_queue_create("setRiddingLocationToDB", NULL);
  dispatch_async(q, ^{
    if([[RiddingLocationDao getSinglton] getRiddingLocationCount:_riddingId]>0){
      return;
    }
    if([[map_dic objectForKey:@"startLocations"] count]==0){
      NSArray *array = [map_dic objectForKey:@"mapTaps"];
      if(!array||[array count]==0){
        return;
      }
      [[MapUtil getSinglton] calculate_routes_from:array map_dic:map_dic];
    }
    if([[map_dic objectForKey:@"startLocations"] count]!=[[map_dic objectForKey:@"toNextDistance"] count]){
      return;
    }
    NSMutableArray *locations=[[NSMutableArray alloc]init];
    int index=0;
    for(CLLocation *location in [map_dic objectForKey:@"startLocations"]){
      RiddingLocation *riddingLocation=[[RiddingLocation alloc]init];
      riddingLocation.latitude=location.coordinate.latitude;
      riddingLocation.longtitude=location.coordinate.longitude;
      riddingLocation.riddingId=_riddingId;
      riddingLocation.toNextDistance=[[map_dic objectForKey:@"toNextDistance"] objectAtIndex:index];
      riddingLocation.weight=[NSNumber numberWithInt:index++];
      [locations addObject:riddingLocation];
    }
    [[RiddingLocationDao getSinglton] addRiddingLocation:_riddingId locations:locations];
  });
}

//插入用户坐标
-(void)updateAnnotations:(NSMutableDictionary*)locations{
  if(locations==nil||self.userArray==nil){
    return;
  }
  NSMutableDictionary* annotationDic=[[NSMutableDictionary alloc]init];
  NSArray* annotations=[self.mapView annotations];
  if(annotations&&[annotations count]>0){
    for(id<MKAnnotation> annotation in annotations){
      if ([annotation isKindOfClass:[UserAnnotation class]]){
        UserAnnotation* userAnnotation=(UserAnnotation*)annotation;
        [annotationDic setValue:userAnnotation forKey:[NSString stringWithFormat:@"%@",userAnnotation.userId]];
      }
    }
  }
  dispatch_queue_t q;
  q=dispatch_queue_create("updateAnnotations", NULL);
  for (User *user in self.userArray) {
    //如果是当前用户
    if([user.userId longLongValue]==[staticInfo.user.userId longLongValue]){
      continue;
    }
    dispatch_async(q, ^{
      
      NSDictionary *dic=[locations objectForKey:[NSString stringWithFormat:@"%@",user.userId]];
      if (dic!=nil) {
        CLLocationDegrees latitude=[[dic objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees longtitude=[[dic objectForKey:@"longtitude"] doubleValue];
        CLLocationCoordinate2D coordinate2D=CLLocationCoordinate2DMake(latitude, longtitude);
        user.speed=[[dic objectForKey:@"speed"]doubleValue];
        user.status=[[dic objectForKey:@"status"]intValue];
        UserAnnotation* userAnnotation=[annotationDic objectForKey:[NSString stringWithFormat:@"%@",user.userId]];
        if(!userAnnotation){
          userAnnotation=[[UserAnnotation alloc]init];
          userAnnotation.userId=user.userId;
          dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotation:userAnnotation];
          });
        }
        userAnnotation.headImage=[user getSSavator];
        userAnnotation.coordinate=coordinate2D;
        userAnnotation.subtitle=[NSString stringWithFormat:@"更新时间:%@",[dic objectForKey:@"timebefore"]];
        userAnnotation.title = user.name;
        user.annotation=userAnnotation;
      }
    });
  }
  int onlineUserCount=0;
  for(UIView *view in [self.userScrollView subviews]){
    if([view isKindOfClass:[UserView class]]){
      UserView *userView=(UserView*)view;
      NSDictionary *dic=[locations objectForKey:[NSString stringWithFormat:@"%@",userView.user.userId]];
      int status=[[dic objectForKey:@"status"]intValue];
      [userView changeStatus:status];
      if(status==1){
        onlineUserCount++;
      }
    }
  }
  self.userOnlineLabel.text=[NSString stringWithFormat:@"在线人数:%d/%d",onlineUserCount,[self.userArray count]];
}

-(void)updatePhotoAnnotation{
  NSArray *pictureArray=[[RiddingPictureDao getSinglton]getRiddingPicture:_riddingId userId:[StaticInfo getSinglton].user.userId];
  if(!pictureArray||[pictureArray count]==0){
    return;
  }
  Photos *photos=[[Photos alloc]init];
  photos.riddingId=_riddingId;
  int index=0;
  for(RiddingPicture *picture in pictureArray){
    CLLocationDegrees latitude=picture.latitude;
    CLLocationDegrees longtitude=picture.longtitude;
    Photos *photos=[[Photos alloc]init];
    photos.riddingId=_riddingId;
    PhotoAnnotation *photoAnnotation=[[PhotoAnnotation alloc]initWithLatitude:latitude andLongitude:longtitude];
    photoAnnotation.image= [photos getPhoto:picture.fileName];
    photoAnnotation.index=index++;
    [self.mapView addAnnotation:photoAnnotation];
  }
}

//放大地图按钮点击
-(void)expandViewClick:(UITapGestureRecognizer*) gestureRecognize{
  MKCoordinateRegion region = self.mapView.region;
  region.span.latitudeDelta=region.span.latitudeDelta / 2;
  region.span.longitudeDelta=region.span.longitudeDelta / 2;
  [self.mapView setRegion:region animated:YES];
}
//缩小地图按钮点击
-(void)reductViewClick:(UITapGestureRecognizer*) gestureRecognize{
  MKCoordinateRegion region = self.mapView.region;
  region.span.latitudeDelta=region.span.latitudeDelta * 2;
  region.span.longitudeDelta=region.span.longitudeDelta * 2;
  [self.mapView setRegion:region animated:YES];
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

-(void)deselectAllAnnotations{
  if(self.mapView){
    NSArray* annotations=[self.mapView annotations];
    if(annotations&&[annotations count]>0){
      for(id<MKAnnotation> annotation in annotations){
        if (![annotation isKindOfClass:[MKUserLocation class]]&&![annotation isKindOfClass:[StartAnnotation class]]&&![annotation isKindOfClass:[EndAnnotation class]]){
          [self.mapView deselectAnnotation:annotation animated:YES];
        }
      }
    }
  }
}

//重新加载当前位置
-(void)reLocationClick:(UITapGestureRecognizer*) gestureRecognize{
  [self sendMyLocationQuartz];
  MKCoordinateRegion region;
  region.center = self.myLocation.location.coordinate;
  region.span = self.mapView.region.span;
  [self.mapView setRegion:region animated:YES];
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
  //    if (_isAnimationing) {
  //        return;
  //    }
  //    UITouch *touch = [touches anyObject];
  //    CGPoint currentPosition = [touch locationInView:self.view];
  //
  //    CGFloat offsetW = currentPosition.x - beginPoint.x;
  //    CGFloat offsetH = currentPosition.y - beginPoint.y;
  //
  //
  //    if (fabsf(offsetW) > fabsf(offsetH)) {
  //        //向右移动,并且点击的是显示用户列表的view
  //        if(offsetW >10&&touch.view==self.userTapView){
  //            //[self membersViewDownToUp:offsetW];
  //        }else if(offsetW <-10 &&touch.view==self.userScrollView){
  //            //从下向上滑动
  //        }
  //    }
  //    else if (fabsf(offsetH) > fabsf(offsetW)) {
  //        if (offsetH < -10 && touch.view == self.userTapView) {
  //            [self membersViewDownToUp];
  //        }
  //        else if(offsetH >10 && touch.view == self.userTapView)
  //            [self membersViewUpToDown];
  //    }
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
  int width=70;
  int height=70;
  int index=1;
  int outheight=height+10;
  int outWidth=width+10;
  int addViewCount=1;
  //如果不是队长是成员
  if(!staticInfo.user.isLeader||[_riddingStatus isEqualToNumber:[NSNumber numberWithInt:20]]){
    addViewCount=0;
    index=0;
  }
  UIImageView *imageView=[[UIImageView alloc]init];
  [imageView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
  [self.userScrollView addSubview:imageView];
  if(self.userArray&&[self.userArray count]>4){
    [imageView setFrame:CGRectMake(0, 0, outWidth*([self.userArray count]+addViewCount), self.userScrollView.frame.size.height)];
  }
  UIView *outActionView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, outWidth, outheight)];
  outActionView.userInteractionEnabled=YES;
  UITapGestureRecognizer *viewTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionViewClick:)];
  [outActionView addGestureRecognizer:viewTap];
  if(staticInfo.user.isLeader&&![_riddingStatus isEqualToNumber:[NSNumber numberWithInt:20]]){
    UIImageView *actionview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 60, 60)];
    UIImage *image=[UIImage imageNamed:@"addUser.png"];
    actionview.image=image;
    [outActionView addSubview:actionview];
  }
  [self.userScrollView addSubview:outActionView];
  self.userScrollView.contentSize = CGSizeMake(width, outheight);
  if (self.userArray&&[self.userArray count]>0) {
    for (User *user in self.userArray) {
      UserView *userView=[[UserView alloc]initWithFrame:CGRectMake(5+(outWidth)*(index++), 5, width, height)];
      userView.user=user;
      userView.userViewDelegate=self;
      userView=[userView init];
      userView.backgroundColor = [UIColor clearColor];
      [self.userScrollView addSubview:userView];
    }
    self.userScrollView.contentSize = CGSizeMake((outWidth)*([self.userArray count]+addViewCount), height);
  }
  self.userScrollView.bounces=YES;
  UILongPressGestureRecognizer *longTap =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longViewClick:)];
  longTap.minimumPressDuration = 0.3;
  [self.userScrollView addGestureRecognizer:longTap];
}
//长按
-(void)longViewClick:(UITapGestureRecognizer*)gestureRecognize{
  if (staticInfo.user.isLeader) {
    isShowDelete=TRUE;
    NSArray *array=[self.userScrollView subviews];
    if(array&&[array count]>0){
      for(UIView *view in array){
        if([view isKindOfClass:[UserView class]]){
          UserView *userView=(UserView*)view;
          userView.deleteView.hidden=NO;
        }
      }
    }
  }
}

//userView.h的代理,点击头像后在地图中间显示
-(void)avatorViewClick:(UITapGestureRecognizer*) gestureRecognize userId:(NSString*)userId{
  if([userId longLongValue]==[staticInfo.user.userId longLongValue]){
    return;
  }
  if(self.userArray){
    for(User *user in self.userArray){
      if([userId longLongValue]==[user.userId longLongValue]){
        MKCoordinateRegion region;
        region.center.latitude=user.annotation.coordinate.latitude;
        region.center.longitude=user.annotation.coordinate.longitude;
        region.span=self.mapView.region.span;
        [self.mapView setRegion:region animated:YES];
        [self.mapView selectAnnotation:user.annotation animated:YES];
        break;
      }
    }
  }
}

//userView.h代理
-(void)deleteViewClick:(UITapGestureRecognizer*) gestureRecognize userView:(UserView*)userView{
  [MobClick event:@"2012070205"];
  CGFloat x=userView.frame.origin.x;
  [requestUtil deleteRiddingUser:_riddingId deleteUserIds:[[NSArray alloc]initWithObjects:userView.user.userId, nil]];
  if(self.userScrollView){
    [userView removeFromSuperview];
    NSArray* userView=[self.userScrollView subviews];
    for(UIView *view in userView){
      if(view.frame.origin.x>x){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        [UIView setAnimationDelegate:self];
        [view setFrame:CGRectMake(view.frame.origin.x-view.frame.size.width-10, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
        [UIView commitAnimations];
      }
    }
  }
  if(self.userArray&&[self.userArray count]>0){
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    for (User *user in self.userArray) {
      if([user.userId longLongValue]!=[userView.user.userId longLongValue]){
        [tempArray addObject:user];
      }
    }
    self.userArray=tempArray;
  }
}
//删除所有UserView
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
//添加用户按钮
-(void)actionViewClick:(UITapGestureRecognizer*) gestureRecognize{
  [MobClick event:@"2012070203"];
  InvitationViewController* invitationView=[[InvitationViewController alloc]init];
  invitationView.riddingId=_riddingId;
  _userInited=FALSE;
  loadingView=[[ActivityView alloc]init:@"获取队员信息" lat:self.view.frame.size.width/2 log:self.view.frame.size.height/2];
  loadingView.hidden=NO;
  [self.view addSubview:loadingView];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSMutableArray* userIdArray=[[NSMutableArray alloc]init];
    for(User *user in self.userArray){
      [userIdArray addObject:user.userId];
    }
    NSDictionary* dic=[requestUtil getAccessUserId:userIdArray souceType:1];
    dispatch_async(dispatch_get_main_queue(), ^{
      for(User *user in self.userArray){
        NSNumber* accessUserId=[dic objectForKey:user.userId];
        if(accessUserId){
          user.accessUserId=[NSString stringWithFormat:@"%@",accessUserId];
          [invitationView.selectedDic setValue:user forKey:user.accessUserId];
          [invitationView.originalDic setValue:user.userId forKey:user.accessUserId];
        }
      }
      [self.navigationController pushViewController:invitationView animated:YES];
      loadingView.hidden=YES;
    });
  });
  [self membersViewUpToDown];
  
  
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
          userView.deleteView.hidden=YES;
        }
      }
    }
    isShowDelete=FALSE;
  }
    [self removeAllCalloutAnnotations];
}

//用户从下往上滑userTap
-(void)membersViewDownToUp
{
  if(!_userInited||!_routesInited){
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
/**
 **(end)
 **userScrollView相关模块
 **/
//annotation
//地图移动的时候的操作
#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
  self.route_view.hidden = YES;
}
//地图移动结束后的操作
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:line_color routes:self.routes];
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
//      if(!myLocationAnnotationView){
//        myLocationAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mylocationAnnotation"];
//        UIImage *annotation_image = [UIImage imageNamed:@"mylocation.png"];
//        myLocationAnnotationView.image=annotation_image;
//        myLocationAnnotationView.opaque=NO;
//      }
//      return myLocationAnnotationView;
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

- (void)photoViewTap:(UIGestureRecognizer*)gesture{
  CalloutMapAnnotationView *view=(CalloutMapAnnotationView*)gesture.view;
  Photos *myPhotos = [[Photos alloc] init];
  myPhotos.riddingId=_riddingId;
  id <KTPhotoBrowserDataSource> dataSource=myPhotos;
  KTPhotoScrollViewController *newController = [[KTPhotoScrollViewController alloc]
                                                initWithDataSource:dataSource
                                                andStartWithPhotoAtIndex:view.index];
  [self.navigationController pushViewController:newController animated:YES];
}

- (void)showCallout:(PhotoAnnotation*)annotation{
  [self.mapView selectAnnotation:annotation animated:YES];
}
//显示用户详情列表
- (void) showDetails{
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    NSDictionary *dic= [[RequestUtil getSinglton]getUserProfile:[StaticInfo getSinglton].user sourceType:SOURCE_SINA];
//    User *_user=[[User alloc]init];
//    [_user setProperties:dic];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        QQNRFeedViewController *QQNRFVC=[QQNRFeedViewController alloc]initWithUser:<#(User *)#> exUser:<#(User *)#>
//    });
//  });
  

}

- (void)viewDidUnload
{
  self.mapView=nil;
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Button Responser
-(IBAction)backBtnClick:(id)sender{
  if(self){
    [self.navigationController popViewControllerAnimated:YES];
  }
}

-(IBAction)showLocationButtonClicked:(id)sender
{
  [self sendMyLocationQuartz];
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
  
  UIImage *photoImg = UIIMAGE_FROMPNG(@"show");
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
  AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                         highlightedImage:storyMenuItemImagePressed
                                                             ContentImage:photoImg
                                                  highlightedContentImage:nil];
//  AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
//                                                         highlightedImage:storyMenuItemImagePressed
//                                                             ContentImage:photoImg
//                                                  highlightedContentImage:nil];
  
  
  NSArray *menus = [NSArray arrayWithObjects:starMenuItem2, starMenuItem3,starMenuItem4, nil];
  
  
  _menu = [[AwesomeMenu alloc] initWithFrame:CGRectMake(-130, 170, 38, 38) menus:menus];
    _menu.frame=CGRectMake(_menu.frame.origin.x, SCREEN_HEIGHT-(460-_menu.frame.origin.y), _menu.frame.size.width, _menu.frame.size.height);
	// customize menu
	_menu.rotateAngle = M_PI/5;
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
    case 2:
    {
      PhotoListViewController *lirVc=[[PhotoListViewController alloc]initWithNibName:@"PhotoListViewController" bundle:nil];
      lirVc.riddingId=_riddingId;
      [self.navigationController pushViewController:lirVc animated:YES];
    }
    case 3:
    {
//      PublicDetailViewController *pdVCTL=[[PublicDetailViewController alloc]initWithNibName:@"PublicDetailViewController" bundle:nil info:_info];
//      [self.navigationController pushViewController:pdVCTL animated:YES];
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
    [self sendMyLocationQuartz];
  }else if(segmentedControl.selectedIndex==SHOWSELF){
    //设置不显示
    _isShowTeamers=FALSE;
  }else{
    [self updatePhotoAnnotation];
  }
}

- (void)showActionSheet{
  UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:@"选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"本地相册",nil];
  actionSheet.delegate=self;
  [actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark takePhotoActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex==0) {
    [MobClick event:@"2012111904"];
    [self showWithCamera];
  }else if(buttonIndex==1){
    [self showWithPhotoLibrary];
  }
  return;
  
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
  [actionSheet setHidden:YES];
  [actionSheet removeFromSuperview];
}

- (void)showWithCamera {
  _isFromCamera=YES;
  UIImagePickerController *imagePicker=[self genImagePicker];
  imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;
  [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
  [self presentModalViewController:imagePicker animated:YES];
}

- (void)showWithPhotoLibrary {
  _isFromCamera = NO;
  UIImagePickerController *imagePicker=[self genImagePicker];
  [[self genImagePicker] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
  [self presentModalViewController:imagePicker animated:YES];
}

- (UIImagePickerController *)genImagePicker {
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  [imagePicker setDelegate:self];
  [imagePicker setAllowsEditing:NO];
  return imagePicker;
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  dispatch_queue_t q;
  q=dispatch_queue_create("didFinishPickingMediaWithInfo", NULL);
  dispatch_async(q, ^{
    int nextDBId=[[RiddingPictureDao getSinglton]getNextDbId:_riddingId userId:[StaticInfo getSinglton].user.userId];
    Photos *photo= [[Photos alloc] init];
    photo.riddingId=_riddingId;
    NSString *fileName=[photo getFileName:_riddingId userId:[StaticInfo getSinglton].user.userId nextDbId:nextDBId];
    //保存到本地数据库
    RiddingPicture *picture = [self saveToDB:fileName dbId:nextDBId];
    picture.image=newImage;
    if(picture){
      dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissModalViewControllerAnimated:NO];
        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:picture,@"picture", nil];
        PhotoDescViewController *descVCTL=[[PhotoDescViewController alloc]initWithNibName:@"PhotoDescViewController" bundle:nil info:dic];
        [self presentModalViewController:descVCTL animated:NO];
      });
      //保存图片
      [photo savePhoto:newImage withName:fileName addToPhotoAlbum:_isFromCamera];
    }
    if(_isFromCamera){
      UIImageWriteToSavedPhotosAlbum(newImage,nil,nil, nil);
    }
  });
}

- (void) video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
  DLog(@"%@",error);
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissModalViewControllerAnimated:YES];
}

- (RiddingPicture*)saveToDB:(NSString*)name dbId:(int)dbId{
  RiddingPicture* picture=[[RiddingPicture alloc]init];
  picture.dbId=[NSNumber numberWithInt:dbId];
  picture.riddingId=_riddingId;
  picture.userId=[StaticInfo getSinglton].user.userId;
  [_myLocation startUpdatingLocation];
  NSDictionary *dic=[[RequestUtil getSinglton]getMapFix:_myLocation.location.coordinate.latitude longtitude:_myLocation.location.coordinate.longitude];
  picture.latitude=[[dic objectForKey:@"realLatitude"]floatValue];
  picture.longtitude=[[dic objectForKey:@"realLongtitude"]floatValue];
  picture.fileName=name;
  picture.text=@"";
  if([[RiddingPictureDao getSinglton] addRiddingPicture:picture]){
    return picture;
  }
  return nil;
}
@end
