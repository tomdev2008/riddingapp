//
//  MyLocationManager.m
//  Ridding
//
//  Created by zys on 13-1-27.
//
//

#import "MyLocationManager.h"
#import "MapFix.h"

static MyLocationManager *manager = nil;

@implementation MyLocationManager

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
    self.locationArray=[[NSMutableArray alloc]init];
    _myLocationManager = [[CLLocationManager alloc] init];
    [_myLocationManager setDelegate:self];
    [_myLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    if ([CLLocationManager headingAvailable]) {
      _myLocationManager.headingFilter = 5;
    }
  }
  return self;
}

- (void)startUpdateMyLocation:(MyLocationBlock)block {

  [_myLocationManager startUpdatingLocation];
  _block = block;
}

#pragma mark locationManager delegate functions
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
  if(_block){
    _block(nil);
  }
  
  [_myLocationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {

  RequestUtil *requestUtil = [[RequestUtil alloc] init];
  NSDictionary *myLocationDic = [requestUtil getMapFix:(CGFloat) _myLocationManager.location.coordinate.latitude longtitude:(CGFloat) _myLocationManager.location.coordinate.longitude];
  MapFix *mapFix = [[MapFix alloc] initWithJSONDic:[myLocationDic objectForKey:keyMapFix]];

  CLLocation *location;
  if (mapFix.realLatitude && mapFix.realLongtitude) {
    location = [[CLLocation alloc] initWithLatitude:mapFix.realLatitude longitude:mapFix.realLongtitude];
  } else {
    location = _myLocationManager.location;
  }
  
  if(count==3){
    [self.locationArray addObject:location];
    count=0;
  }
  count++;

  CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
  [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
    QQNRMyLocation *myLocation = [[QQNRMyLocation alloc] init];
    if (placemarks) {
      CLPlacemark *mark = [placemarks objectAtIndex:0];
      myLocation.name = mark.name;
      if (mark.locality) {
        myLocation.city = mark.locality;
      } else {
        myLocation.city = mark.subLocality;
      }

      myLocation.latitude = location.coordinate.latitude;
      myLocation.longtitude = location.coordinate.longitude;
      myLocation.location = [[CLLocation alloc] initWithLatitude:myLocation.latitude longitude:myLocation.longtitude];
      if(_block){
        _block(myLocation);
        _block=nil;
      }
      [_myLocationManager stopUpdatingLocation];
    }
    [geoCoder cancelGeocode];
  }];
}

@end
