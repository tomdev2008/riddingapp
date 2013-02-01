//
//  User.h
//  Ridding
//
//  Created by zys on 12-3-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAnnotation.h"
#import "BasicObject.h"

#define keyUser @"user"
#define keyToUser @"touser"
typedef enum _SOURCETYPE {
  SOURCE_SINA = 1,
  SOURCE_WEB = 2,
} SOURCETYPE;

@interface User : BasicObject {
}

@property (nonatomic, retain) NSString *statusTitle;
@property (nonatomic, retain) UIImage *avatorImage;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) UserAnnotation *annotation;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) long long userId;
@property (nonatomic, retain) NSString *bavatorUrl;
@property (nonatomic, retain) NSString *savatorUrl;
@property (nonatomic) long long sourceUserId;
@property (nonatomic) int totalDistance;
@property (nonatomic) int userRole;
@property (nonatomic, retain) NSString *authToken;
@property (nonatomic) double speed;
@property (nonatomic) int sourceType;
@property (nonatomic) int nowRiddingCount;
@property (nonatomic) BOOL isLeader;
@property (nonatomic) int status;
@property (nonatomic, copy) NSString *timeBefore;
@property (nonatomic) double latitude;
@property (nonatomic) double longtitude;
@property (nonatomic, copy) NSString *backGroundUrl;


//选好友的时候用到
@property (nonatomic) BOOL isSelected;

- (NSString *)getTotalDistanceToKm;


@end
