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
  
}

@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic) Ridding *nowRidding;

+ (id)getSingleton;


- (void)startBackgroundLocation;

- (void)stopBackgroundLocation;

- (void)startUpdateLocation;

- (void)stopUpdateLocation;

+ (NSArray*)uploadRiddingMap:(long long)riddingId userId:(long long)userId;

@end
