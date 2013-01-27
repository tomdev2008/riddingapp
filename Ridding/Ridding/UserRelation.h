//
//  UserRelation.h
//  Ridding
//
//  Created by zys on 13-1-4.
//
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserRelation : BasicObject


@property (nonatomic, retain) User *user;
@property (nonatomic, retain) User *toUser;
@property (nonatomic) long long dbId;
@property (nonatomic) int status;
@property (nonatomic) long long createTime;
@end
