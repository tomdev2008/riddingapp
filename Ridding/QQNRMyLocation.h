//
//  MyLocation.h
//  Ridding
//
//  Created by zys on 12-12-1.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface QQNRMyLocation : NSObject

//如果没错误，得到的是修复过的位置
@property (nonatomic) double latitude;
@property (nonatomic) double longtitude;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, retain) CLLocation *location;
@end
