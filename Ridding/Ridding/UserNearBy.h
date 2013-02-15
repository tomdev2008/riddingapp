//
//  UserNearBy.h
//  Ridding
//
//  Created by zys on 13-2-8.
//
//

#import "BasicObject.h"
#import "User.h"
#define keyUserNearBy @"usernearby"
@interface UserNearBy : BasicObject

@property (nonatomic) int distance;
@property (nonatomic) User *user;

@end
