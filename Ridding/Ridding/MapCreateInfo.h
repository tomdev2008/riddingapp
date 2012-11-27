//
//  MapCreateInfo.h
//  Ridding
//
//  Created by zys on 12-11-17.
//
//

#import <Foundation/Foundation.h>

@interface MapCreateInfo : NSObject

@property(nonatomic,copy) NSString *riddingName;
@property(nonatomic) int distance;
@property(nonatomic,copy) NSString *beginLocation;
@property(nonatomic,copy) NSString *endLocation;
@property(nonatomic,retain) NSArray *midLocations;
@property(nonatomic,copy) NSString *cityName;
//还没用
@property(nonatomic,copy) NSString *mapUrl;
@property(nonatomic,retain) NSArray *mapTaps;
@property(nonatomic,retain) NSArray *points;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,retain) UIImage *coverImage;
@property(nonatomic,copy) NSString *urlKey;
@end
