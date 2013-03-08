//
//  MyLocationManager.h
//  Ridding
//
//  Created by zys on 13-1-27.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "QQNRMyLocation.h"

typedef void (^MyLocationBlock)(QQNRMyLocation *);


@interface MyLocationManager : NSObject <CLLocationManagerDelegate>{
  int count;
}

@property (nonatomic, retain) CLLocationManager *myLocationManager;
@property (nonatomic, copy) MyLocationBlock block;
@property (nonatomic, retain) NSMutableArray *locationArray;


+ (id)getSingleton;

- (void)startUpdateMyLocation:(MyLocationBlock)block;


@end
