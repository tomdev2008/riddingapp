//
//  GpsLocationManager.m
//  Ridding
//
//  Created by zys on 13-3-14.
//
//

#import "GpsLocationManager.h"

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
    _myLocationManager = [[CLLocationManager alloc] init];
    [_myLocationManager setDelegate:self];
    [_myLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    if ([CLLocationManager headingAvailable]) {
      _myLocationManager.headingFilter = 5;
    }
  }
  return self;
}

@end
