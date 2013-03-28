//
//  GpsLocationManager.m
//  Ridding
//
//  Created by zys on 13-3-14.
//
//

#import "GpsLocationManager.h"
#import "GpsDao.h"
#import "Gps.h"
#import "MapFix.h"
#import "RequestUtil.h"
#import "MapUtil.h"
#import "RiddingMapPointDao.h"
static const CGFloat kRequiredHorizontalAccuracy = 20.0;
static GpsLocationManager *manager = nil;
@implementation GpsLocationManager


+ (id)getSingleton {
  
  @synchronized (self) {
    if (manager == nil) {
      manager = [[self alloc] init]; // assignment not done here
      
    }
  }
  return manager;
}


- (id)init {
  
  self = [super init];
  if (self) {
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    _locationManager.distanceFilter=10.0f;
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    if ([CLLocationManager headingAvailable]) {
      _locationManager.headingFilter = 5;
    }
  }
  return self;
}

- (void)startBackgroundLocation{
  
  if([StaticInfo getSinglton].logined&&_nowRidding){
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
      // Stop normal location updates and start significant location change updates for battery efficiency.
      [_locationManager startUpdatingLocation];
      [_locationManager startMonitoringSignificantLocationChanges];
    }
    else {
      NSLog(@"Significant location change monitoring is not available.");
    }
  }
}

- (void)stopBackgroundLocation{
  if([StaticInfo getSinglton].logined&&_nowRidding){
    if ([CLLocationManager significantLocationChangeMonitoringAvailable])
    {
      // Stop significant location updates and start normal location updates again since the app is in the forefront.
      [_locationManager stopMonitoringSignificantLocationChanges];
      [_locationManager stopUpdatingLocation];
    }
    else
    {
      NSLog(@"Significant location change monitoring is not available.");
    }
  }
}


#pragma mark locationManager delegate functions
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
  
   
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  
  
  Gps *gps=[[Gps alloc]init];
  gps.riddingId=_nowRidding.riddingId;
  gps.latitude=newLocation.coordinate.latitude;
  gps.longtitude=newLocation.coordinate.longitude;
  gps.userId=_nowRidding.leaderUser.userId;
  [GpsDao addGps:gps];
  
}


- (void)startUpdateLocation{
  
  [_locationManager startUpdatingLocation];
}

- (void)stopUpdateLocation{
  
  [_locationManager stopUpdatingLocation];
}


+ (NSArray*)uploadRiddingMap:(long long)riddingId userId:(long long)userId{
  NSArray *gpsArray=[GpsDao getGpss:riddingId userId:userId];
  RequestUtil *requestUtil = [[RequestUtil alloc] init];
  NSMutableArray *pointArray=[[NSMutableArray alloc]init];
  for(Gps *gps in gpsArray){
//    NSLog(@"%f",gps.fixedLatitude);
//    NSLog(@"%f",gps.fixedLongtitude);
    if(gps.fixedLatitude==0&&gps.fixedLongtitude==0){
      NSMutableDictionary *mulDic=[[NSMutableDictionary alloc]init];
      SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(mulDic, DOUBLE2STR(gps.latitude), @"latitude");
      SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(mulDic, DOUBLE2STR(gps.longtitude), @"longitude");
      [pointArray addObject:mulDic];
     }
  }
  if([pointArray count]!=0){
    NSArray *array = [requestUtil getMapFixs:pointArray];
    NSMutableDictionary *returnDic=[[NSMutableDictionary alloc]init];
    for(NSDictionary *dic in array){
      MapFix *mapFix = [[MapFix alloc] initWithJSONDic:[dic objectForKey:keyMapFix]];
      
      NSString *key=[NSString stringWithFormat:@"%@_%@",DOUBLE2STR(mapFix.latitude),DOUBLE2STR(mapFix.longtitude)];
      SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(returnDic, mapFix, key);
    }
    
    for(Gps *gps in gpsArray){
      if(gps.fixedLatitude!=0||gps.fixedLongtitude!=0){
        continue;
      }
      MapFix *mapFix=[returnDic objectForKey:[NSString stringWithFormat:@"%@_%@",DOUBLE2STR(gps.latitude),DOUBLE2STR(gps.longtitude)]];
      //    NSLog(@"%lf",mapFix.realLatitude);
      //    NSLog(@"%lf",mapFix.realLongtitude);
      //    NSLog(@"aaa%f",gps.fixedLongtitude);
      //    NSLog(@"aaa%f",gps.fixedLatitude);
      //    NSLog(@"aaa%lld",gps.dbId);
      gps.fixedLatitude=mapFix.realLatitude;
      gps.fixedLongtitude=mapFix.realLongtitude;
      [GpsDao updateReal:gps];
    }

  }
  NSString *encodePolyLine=[[MapUtil getSinglton] encodePolyLine:gpsArray];
  
  NSMutableArray *mapPoints=[[NSMutableArray alloc]init];
  [mapPoints addObject:encodePolyLine];
  
  [requestUtil uploadRiddingGps:riddingId mapPoints:mapPoints];
  [RiddingMapPointDao addOrUpdateRiddingMapPointToDB:[mapPoints JSONRepresentation] riddingId:riddingId userId:userId];
  NSFileManager *manager = [NSFileManager defaultManager];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
  //删除本地image
  NSString *savePath= [[paths objectAtIndex:0] stringByAppendingPathComponent:
                       [NSString stringWithFormat:@"b_%lld_%lld.png",riddingId,userId]];
  [manager removeItemAtPath:savePath error:nil];
  savePath= [[paths objectAtIndex:0] stringByAppendingPathComponent:
             [NSString stringWithFormat:@"s_%lld_%lld.png",riddingId,userId]];
  [manager removeItemAtPath:savePath error:nil];
  return gpsArray;
}

@end
