//
//  Ridding.h
//  Ridding
//
//  Created by zys on 12-12-6.
//
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Map.h"
#import "RiddingPicture.h"
#import "Public.h"
#define keyRidding @"ridding"

typedef enum _RIDDINGACTION {
  RIDDINGACTION_LIKE = 0,
  RIDDINGACTION_CARE = 1,
  RIDDINGACTION_FINISH = 2,
  RIDDINGACTION_USE = 3,
  RIDDINGACTION_LIKEPICTURE = 4,
} RIDDINGACTION;


@interface Ridding : BasicObject {

}

@property (nonatomic) long long riddingId;
@property (nonatomic) int riddingStatus;
@property (nonatomic) int userCount;
@property (nonatomic, copy) NSString *riddingName;
@property (nonatomic, retain) User *leaderUser;
//当前用户的userrole
@property (nonatomic) int userRole;
@property (nonatomic) int riddingType;
@property (nonatomic) long long createTime;
@property (nonatomic, copy) NSString *createTimeStr;
@property (nonatomic) long long lastUpdateTime;
@property (nonatomic, copy) NSString *lastUpdateTimeStr;
@property (nonatomic, retain) Map *map;
@property (nonatomic, retain) NSMutableArray *riddingPictures;
@property (nonatomic) int isPublic;
@property (nonatomic) int isRecom;
@property (nonatomic) int isSyncSina;


@property (nonatomic) int likeCount;
@property (nonatomic) int useCount;
@property (nonatomic) int careCount;
@property (nonatomic) int commentCount;

@property (nonatomic) BOOL nowUserLiked;
@property (nonatomic) BOOL nowUserCared;
@property (nonatomic) BOOL nowUserUsed;
@property (nonatomic,retain) Public *aPublic;

- (BOOL)isEnd;

- (void)setEnd;

+ (BOOL)isLeader:(int)userRole;

- (BOOL)syncSina;
@end
