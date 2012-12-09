//
//  Map.h
//  Ridding
//
//  Created by zys on 12-12-6.
//
//

#import <Foundation/Foundation.h>
#import "BasicObject.h"
@interface Map : BasicObject


@property(nonatomic) long long mapId;
@property(nonatomic,copy) NSString *mapUrl;
@property(nonatomic,retain) NSArray *mapTaps;
@property(nonatomic) long long createTime;
@property(nonatomic,copy) NSString *createTimeStr;
@property(nonatomic) long long objectId;
@property(nonatomic) int objectType;
@property(nonatomic) int status;
@property(nonatomic,retain) NSArray *mapPoint;
@property(nonatomic) int distance;
@property(nonatomic,copy) NSString *beginLocation;
@property(nonatomic,copy) NSString *endLocation;
@property(nonatomic,copy) NSString *midLocation;
@property(nonatomic,retain) NSArray *midLocations;
@property(nonatomic) long long cityId;
@property(nonatomic,copy) NSString *avatorPicUrl;
@property(nonatomic,copy) NSString *cityName;
@property(nonatomic,copy) NSString *urlKey;
@property(nonatomic,retain) UIImage *coverImage;


@property(nonatomic,copy) NSString *riddingName;


@property (nonatomic,retain) NSArray *toNextDistance;
@property (nonatomic,retain) NSArray *startLocations;

@end
