//
//  User.h
//  Ridding
//
//  Created by zys on 12-3-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAnnotation.h"

typedef enum _SOURCETYPE {
	SOURCE_SINA = 1,
	SOURCE_WEB = 2,
}SOURCETYPE;

@interface User : NSObject {
    int status;
    int sourceType;
    NSString* statusTitle;
    UIImage *avator;
    double speed;
    NSString *accessToken;
    UserAnnotation *annotation;
    NSString *name;
    NSString *userId;
    NSString *accessUserId;
    NSString *bavatorUrl;
    NSString *savatorUrl;
    NSString *totalDistance;
    NSNumber *userRole;
    bool isLeader;
}
@property(nonatomic, retain) NSString* statusTitle;
@property(nonatomic, retain) UIImage *avator;
@property(nonatomic, retain) NSString *accessToken;
@property(nonatomic, retain) UserAnnotation *annotation;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *userId;
@property(nonatomic, retain) NSString *bavatorUrl;
@property(nonatomic, retain) NSString *savatorUrl;
@property(nonatomic, retain) NSString *accessUserId;
@property(nonatomic, retain) NSString *totalDistance;
@property(nonatomic, retain) NSNumber *userRole;
@property(nonatomic, retain) NSString *authToken;
@property(nonatomic) double speed;
@property(nonatomic) bool isLeader;
@property(nonatomic) int status;
@property(nonatomic) int sourceType;
@property(nonatomic) int nowRiddingCount;


-(UIImage*)getSavator;
-(UIImage*)getBavator;
-(UIImage*)OriginImage:(UIImage *)image   scaleToSize:(CGSize)size;
-(UIImage*) getSSavator;
-(NSString*) getTotalDistanceToKm;
-(void)setProperties:(NSDictionary*)dic;

@end
