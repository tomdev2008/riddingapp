//
//  Comment.h
//  Ridding
//
//  Created by zys on 12-12-8.
//
//

#import "BasicObject.h"
#import "User.h"
#define keyComment @"comment"
typedef enum _COMMENTTYPE {
  COMMENTTYPE_COMMENT,
  COMMENTTYPE_REPLY
} COMMENTTYPE;

@interface Comment : BasicObject

@property (nonatomic) long long dbId;
@property (nonatomic) long long riddingId;
@property (nonatomic) long long userId;
@property (nonatomic) long long toUserId;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) User *toUser;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *usePicUrl;
@property (nonatomic) int commentType;
@property (nonatomic) long long replyId;
@property (nonatomic) long long createTime;
@property (nonatomic, copy) NSString *createTimeStr;
@property (nonatomic, copy) NSString *beforeTime;
@end
