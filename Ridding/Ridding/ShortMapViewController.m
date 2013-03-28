//
//  ShotMapViewController.m
//  Ridding
//
//  Created by zys on 13-3-13.
//
//

#import "ShortMapViewController.h"
#import "Gps.h"
#import "GpsDao.h"
#import "MapFix.h"
#import "MapUtil.h"
#import "UIColor+XMin.h"
#import "SVProgressHUD.h"
#import "MyLocationManager.h"
#import "RiddingMapPointDao.h"
#import "RiddingMapPoint.h"
#import "BlockAlertView.h"
#import "GpsLocationManager.h"
#import "PSLocationManager.h"
@interface ShortMapViewController ()

@end

@implementation ShortMapViewController

- (id)initWithUser:(User *)toUser ridding:(Ridding *)ridding isMyFeedHome:(BOOL)isMyFeedHome{
  self = [super init];
  if (self) {
    _toUser = toUser;
    _ridding = ridding;
    _isMyFeedHome=isMyFeedHome;
  }
  return self;

}

- (void)viewDidLoad
{
  _routes = [[NSMutableArray alloc] init];
  self.hasLeftView = FALSE;
  [super viewDidLoad];
  
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeToFrontNotif:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  
  [super viewDidAppear:animated];
  if (!self.didAppearOnce) {
    self.didAppearOnce = YES;
    [self checkLocation];
    [self checkLocationUpdate];
    [self drawMyRoutes];
  }
}

- (void)leftBtnClicked:(id)sender {
  
  if([_ridding isEnd]){
    [self.navigationController popViewControllerAnimated:YES];
    return;
  }
  BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"tips" message:@"离开gps页面需要暂停或者结束当前骑行记录"];
  [alert setCancelButtonWithTitle:@"暂停" block:^(void) {
    
    PSLocationManager *locationManager=[PSLocationManager sharedLocationManager];
    locationManager.delegate=nil;
    [locationManager stopLocationUpdates];
    locationManager.nowRidding=nil;
    locationManager.nowUser=nil;
    [self.navigationController popViewControllerAnimated:YES];
  }];
  [alert addButtonWithTitle:@"结束这次骑行" block:^{
    [self.requestUtil finishActivity:_ridding.riddingId];
    [GpsLocationManager uploadRiddingMap:_ridding.riddingId userId:_toUser.userId];
    [self.navigationController popViewControllerAnimated:YES];
  }];
  [alert show];
}

- (void)checkLocationUpdate{
  
  if(![_ridding isEnd]&&_isMyFeedHome){
    BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"tips" message:@"骑行gps记录即将开始。。"];
    [alert setCancelButtonWithTitle:@"开始吧!" block:^(void) {
      PSLocationManager *manager=[PSLocationManager sharedLocationManager];
      manager.nowRidding=_ridding;
      manager.nowUser=_toUser;
      manager.delegate=self;
      [manager startLocationUpdates];
    }];
    [alert show];

  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)comeToFrontNotif:(NSNotification *)notif{
  
  UIViewController *controller=[self.navigationController topViewController];
  if([controller isMemberOfClass:[ShortMapViewController class]]){
    if(_isMyFeedHome){
      [self drawMyRoutes];
    }
  }
}


- (void)drawMyRoutes {
  
  [SVProgressHUD showWithStatus:@"制作路线中,请稍候"];
  dispatch_queue_t q;
  q = dispatch_queue_create("drawMyRoutes", NULL);
  dispatch_async(q, ^{
    if([_ridding isEnd]){
      [self getMapWithEnd];
    }else{
      [_routes removeAllObjects];
      NSArray *array=[GpsLocationManager uploadRiddingMap:_ridding.riddingId userId:_toUser.userId];
      for(Gps *gps in array){
        if(gps.fixedLongtitude==0&&gps.fixedLatitude==0){
          continue;
        }
        CLLocation *location=[[CLLocation alloc]initWithLatitude:gps.fixedLatitude longitude:gps.fixedLongtitude];
        [_routes addObject:location];
      }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      if (self&&[_routes count]>0) {
        [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:[UIColor getColor:lineColor] routes:_routes width:5.0];
        [[MapUtil getSinglton] center_map:self.mapView routes:_routes];
      }
      [SVProgressHUD dismiss];
    });
  });
}

- (void)getMapWithEnd{
  NSArray *tempRoutes=(NSArray*)[[StaticInfo getSinglton].routesDic objectForKey:[StaticInfo routeDicKey:_ridding.riddingId userId:_toUser.userId]];
  [_routes addObjectsFromArray:tempRoutes];
  if(!_routes||[_routes count]==0){
    RiddingMapPoint *riddingMapPoint=[RiddingMapPointDao getRiddingMapPoint:_ridding.riddingId userId:_toUser.userId];
    if (riddingMapPoint) {
      [_routes addObjectsFromArray:[[MapUtil getSinglton] decodePolyLineArray:[riddingMapPoint.mappoint JSONValue]]];
    } else {
      //如果数据库中存在，那么取数据库中的地图路径，如果不存在，http去请求服务器。
      //数据库中取出是mapTaps或者points
      NSMutableDictionary *map_dic = [self.requestUtil getMapMessage:_ridding.riddingId userId:_toUser.userId];
      Map *map = [[Map alloc] initWithJSONDic:[map_dic objectForKey:keyMap]];
      [_routes addObjectsFromArray:[[MapUtil getSinglton] decodePolyLineArray:map.mapPoint]];
      [RiddingMapPointDao addRiddingMapPointToDB:[map.mapPoint JSONRepresentation] riddingId:_ridding.riddingId userId:_toUser.userId];
    }
    [[StaticInfo getSinglton].routesDic setObject:_routes forKey:[StaticInfo routeDicKey:_ridding.riddingId userId:_toUser.userId]];
  }
}

- (void)checkLocation {
  
  if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    [SVProgressHUD showSuccessWithStatus:@"请开启定位服务以定位到您的位置" duration:2.0];
  } else {
    MyLocationManager *manager = [MyLocationManager getSingleton];
    [manager startUpdateMyLocation:^(QQNRMyLocation *location) {
      MKCoordinateRegion region;
      region.center = location.location.coordinate;
      region.span = MKCoordinateSpanMake(0.1, 0.1);
      [self.mapView setRegion:region animated:YES];
    }];
  }
}

#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
  
  self.route_view.hidden = YES;
}

//地图移动结束后的操作
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  
  [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:[UIColor getColor:lineColor] routes:_routes width:5.0];
  self.route_view.hidden = NO;
  [self.route_view setNeedsDisplay];
}


- (void)locationManager:(PSLocationManager *)locationManager waypoint:(CLLocation *)waypoint calculatedSpeed:(double)calculatedSpeed altitude:(double)altitude{
  _speedLabel.text=[NSString stringWithFormat:@"%f",calculatedSpeed];
  _altitudeLabel.text=[NSString stringWithFormat:@"%f",altitude];
}
@end
