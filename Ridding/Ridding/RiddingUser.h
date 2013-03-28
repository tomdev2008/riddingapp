//
//  RiddingUser.h
//  Ridding
//
//  Created by zys on 13-3-26.
//
//

#import "BasicObject.h"
#import "User.h"
#import "GpsMap.h"
#define keyRiddingUser @"riddinguser"
@interface RiddingUser : BasicObject

@property(nonatomic,retain) User *user;
@property(nonatomic) int userRole;
@property(nonatomic,retain) GpsMap *gpsMap;

@end
