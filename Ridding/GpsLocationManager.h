//
//  GpsLocationManager.h
//  Ridding
//
//  Created by zys on 13-3-14.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface GpsLocationManager : NSObject<CLLocationManagerDelegate>{
  CLLocationManager *_myLocationManager;
}


+ (id)getSingleton;
@end
