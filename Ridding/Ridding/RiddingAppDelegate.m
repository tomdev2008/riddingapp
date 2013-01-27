//
//  RiddingAppDelegate.m
//  Ridding
//
//  Created by zys on 12-3-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "QQNRFeedViewController.h"
#import "MapFix.h"

#define moveSpeed 0.5

@implementation RiddingAppDelegate
@synthesize window = _window;
@synthesize rootViewController = _rootViewController;
@synthesize navController = _navController;
@synthesize myLocationManager = _myLocationManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
  });

  _myLocation = [[QQNRMyLocation alloc] init];
  _myLocationManager = [[CLLocationManager alloc] init];
  [_myLocationManager setDelegate:self];
  [_myLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
  [_myLocationManager startUpdatingLocation];
  if ([CLLocationManager headingAvailable]) {
    _myLocationManager.headingFilter = 5;
  }

  [MobClick startWithAppkey:YouMenAppKey reportPolicy:REALTIME channelId:nil];
  [MobClick checkUpdate];
  [[ResponseCodeCheck getSinglton] checkConnect];

  //检查网络
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  [self setUserInfo];

  self.rootViewController = [[PublicViewController alloc] init];

  self.navController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];

  self.navController.navigationBar.hidden = YES;
  self.window.rootViewController = self.navController;


  self.leftViewController = [[BasicLeftViewController alloc] init];
  self.leftViewController.view.frame = CGRectMake(0, 20, self.leftViewController.view.frame.size.width, self.leftViewController.view.frame.size.height);

  [self.window addSubview:self.leftViewController.view];
  [self.window addSubview:self.navController.view];

  [self.window makeKeyAndVisible];

  return YES;
}

- (void)setUserInfo {

  StaticInfo *staticInfo = [StaticInfo getSinglton];
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  staticInfo.user.userId = [[prefs stringForKey:kStaticInfo_userId] longLongValue];
  staticInfo.user.authToken = [prefs stringForKey:kStaticInfo_authToken];
  staticInfo.user.sourceUserId = [[prefs stringForKey:kStaticInfo_accessUserId] longLongValue];
  staticInfo.user.accessToken = [prefs stringForKey:kStaticInfo_accessToken];
  staticInfo.user.sourceType = [prefs integerForKey:kStaticInfo_sourceType];
  staticInfo.user.backGroundUrl = [prefs stringForKey:kStaticInfo_backgroundUrl];
  staticInfo.user.totalDistance = [prefs integerForKey:kStaticInfo_totalDistance];
  staticInfo.user.name = [prefs objectForKey:kStaticInfo_nickname];
  staticInfo.user.savatorUrl = [prefs objectForKey:kStaticInfo_savatorUrl];
  staticInfo.user.bavatorUrl = [prefs objectForKey:kStaticInfo_bavatorUrl];
}

- (BOOL)canLogin {

  StaticInfo *staticInfo = [StaticInfo getSinglton];

  if (staticInfo.logined) {
    return TRUE;
  }
  RequestUtil *requestUtil = [[RequestUtil alloc] init];
  NSDictionary *userProfileDic = [requestUtil getUserProfile:staticInfo.user.userId sourceType:staticInfo.user.sourceType];
  User *user = [[User alloc] initWithJSONDic:[userProfileDic objectForKey:@"user"]];
  //如果新浪成功，并且authtoken有效
  if (staticInfo.user.accessToken != nil && userProfileDic != nil) {
    staticInfo.user.name = user.name;
    staticInfo.user.bavatorUrl = user.bavatorUrl;
    staticInfo.user.savatorUrl = user.savatorUrl;
    staticInfo.user.totalDistance = user.totalDistance;
    staticInfo.user.nowRiddingCount = user.nowRiddingCount;
    staticInfo.user.backGroundUrl = user.backGroundUrl;
    staticInfo.logined = TRUE;
    return TRUE;
  }
  return FALSE;
}

+ (BOOL)isMyFeedHome:(User *)user {

  if ([StaticInfo getSinglton].user && [StaticInfo getSinglton].user.userId == user.userId && user.userId > 0) {
    return TRUE;
  }
  return FALSE;
}

- (NSString *)getPlist:(NSString *)key {

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectoryPath = [paths objectAtIndex:0];
  NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:@"Ridding-Info.plist"];
  NSMutableDictionary *DictPlist = [NSDictionary dictionaryWithContentsOfFile:path];
  return [DictPlist objectForKey:key];
}


//iPhone 从APNs服务器获取deviceToken后回调此方法
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

  NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs setObject:dt forKey:kStaticInfo_apnsToken];
}

//注册push功能失败 后 返回错误信息，执行相应的处理
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
}


#pragma mark locationManager delegate functions
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {

  _canGetLocation = FALSE;
  [[NSNotificationCenter defaultCenter] postNotificationName:kFailUpdateMyLocationNotification object:self userInfo:nil];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {

  _canGetLocation = TRUE;
  RequestUtil *requestUtil = [[RequestUtil alloc] init];
  NSDictionary *myLocationDic = [requestUtil getMapFix:_myLocationManager.location.coordinate.latitude longtitude:_myLocationManager.location.coordinate.longitude];
  MapFix *mapFix = [[MapFix alloc] initWithJSONDic:[myLocationDic objectForKey:@"mapfix"]];

  CLLocation *location;
  if (mapFix.realLatitude && mapFix.realLongtitude) {
    location = [[CLLocation alloc] initWithLatitude:mapFix.realLatitude longitude:mapFix.realLongtitude];
  } else {
    location = _myLocationManager.location;
  }
  CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
  [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
    if (placemarks) {
      CLPlacemark *mark = [placemarks objectAtIndex:0];
      _myLocation.name = mark.name;
      if (mark.locality) {
        _myLocation.city = mark.locality;
      } else {
        _myLocation.city = mark.subLocality;
      }

      _myLocation.latitude = location.coordinate.latitude;
      _myLocation.longtitude = location.coordinate.longitude;
      _myLocation.location = [[CLLocation alloc] initWithLatitude:_myLocation.latitude longitude:_myLocation.longtitude];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kFinishUpdateMyLocationNotification object:self userInfo:nil];
  }];
}

- (BOOL)canGetLocation {

  return _canGetLocation;
}

- (CLLocationManager *)myLocationManager {

  return _myLocationManager;
}

- (QQNRMyLocation *)myLocation {

  [_myLocationManager startUpdatingLocation];
  return _myLocation;
}

- (NSString *)myLocationCity {

  return _myLocation.city;
}

- (void)startUpdateMyLocation {

  [_myLocationManager startUpdatingLocation];
}

- (void)startUpdateMyLocationHeading {

  [_myLocationManager startUpdatingHeading];
}

+ (RiddingAppDelegate *)shareDelegate {

  return (RiddingAppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

//进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {

  if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
    // Stop normal location updates and start significant location change updates for battery efficiency.
    [_myLocationManager stopUpdatingLocation];
  }
  else {
    NSLog(@"Significant location change monitoring is not available.");
  }
}

//回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application {

  if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
    // Stop normal location updates and start significant location change updates for battery efficiency.
    [_myLocationManager startUpdatingLocation];
  }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application {
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}


+ (void)moveMidNavgation {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  //往左移动
  [UIView animateWithDuration:moveSpeed animations:^{
    delegate.navController.view.frame = CGRectMake(LeftBarMoveWidth,
        delegate.navController.view.frame.origin.y,
        delegate.navController.view.frame.size.width,
        delegate.navController.view.frame.size.height);

  }
                   completion:^(BOOL finish) {
                     ((BasicViewController *) delegate.navController.visibleViewController).position = POSITION_MID;
                     [delegate.leftViewController showShadow];
                   }];

}

+ (void)moveLeftNavgation {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  //往左移动
  [UIView animateWithDuration:moveSpeed animations:^{
    delegate.navController.view.frame = CGRectMake(0,
        delegate.navController.view.frame.origin.y,
        delegate.navController.view.frame.size.width,
        delegate.navController.view.frame.size.height);

  }
                   completion:^(BOOL finish) {
                     ((BasicViewController *) delegate.navController.visibleViewController).position = POSITION_LEFT;
                   }];
}

+ (void)moveRightNavgation {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  //往右移动
  [UIView animateWithDuration:moveSpeed animations:^{
    delegate.navController.view.frame = CGRectMake(SCREEN_WIDTH,
        delegate.navController.view.frame.origin.y,
        delegate.navController.view.frame.size.width,
        delegate.navController.view.frame.size.height);

  }
                   completion:^(BOOL finish) {
                     ((BasicViewController *) delegate.navController.visibleViewController).position = POSITION_RIGHT;

                   }];
}

+ (void)popAllNavgation {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  [delegate.navController popToRootViewControllerAnimated:NO];
  [delegate.navController popViewControllerAnimated:NO];
}


@end
