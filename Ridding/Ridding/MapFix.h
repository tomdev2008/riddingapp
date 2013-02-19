//
//  MapFix.h
//  Ridding
//
//  Created by zys on 12-12-6.
//
//

#import "BasicObject.h"
#define keyMapFix @"mapfix"
@interface MapFix : BasicObject

@property (nonatomic) double latitude;
@property (nonatomic) double longtitude;
@property (nonatomic) double realLatitude;
@property (nonatomic) double realLongtitude;
@end
