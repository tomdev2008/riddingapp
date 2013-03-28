//
//  Gps.h
//  Ridding
//
//  Created by zys on 13-3-12.
//
//

#import "BasicObject.h"

@interface Gps : BasicObject

@property (nonatomic) long long dbId;
@property (nonatomic) double latitude;
@property (nonatomic) double longtitude;
@property (nonatomic) long long riddingId;
@property (nonatomic) long long userId;
@property (nonatomic) double fixedLatitude;
@property (nonatomic) double fixedLongtitude;
@property (nonatomic) double altitude;
@property (nonatomic) double speed;
@end
