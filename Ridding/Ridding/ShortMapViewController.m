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
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)comeToFrontNotif:(NSNotification *)notif{
  
  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  UIViewController *controller=[delegate.navController visibleViewController];
  if([controller isKindOfClass:[ShortMapViewController class]]){
    
    [self drawMyRoutes];
  }
  
}


- (void)drawMyRoutes {
  
  [SVProgressHUD showWithStatus:@"请稍候"];
  dispatch_queue_t q;
  q = dispatch_queue_create("drawMyRoutes", NULL);
  dispatch_async(q, ^{
    NSArray *array=[GpsDao getGpss:_ridding.riddingId userId:_toUser.userId];
    for(Gps *gps in array){
      RequestUtil *requestUtil = [[RequestUtil alloc] init];
      NSDictionary *myLocationDic = [requestUtil getMapFix:(CGFloat) gps.latitude longtitude:(CGFloat)gps.longtitude];
      MapFix *mapFix = [[MapFix alloc] initWithJSONDic:[myLocationDic objectForKey:keyMapFix]];
      gps.fixedLatitude=mapFix.realLatitude;
      gps.longtitude=mapFix.realLongtitude;
      [GpsDao updateReal:gps];
      CLLocation *location=[[CLLocation alloc]initWithLatitude:mapFix.realLatitude longitude:mapFix.realLongtitude];
      [_routes addObject:location];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      if (self&&[_routes count]>0) {
        [[MapUtil getSinglton] update_route_view:self.mapView to:self.route_view line_color:[UIColor getColor:lineColor] routes:_routes width:5.0];
        [[MapUtil getSinglton] center_map:self.mapView routes:_routes];
        [SVProgressHUD dismiss];
      }
    });
  });
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
@end
