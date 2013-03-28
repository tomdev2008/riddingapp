//
//  Ridding.m
//  Ridding
//
//  Created by zys on 12-12-6.
//
//

@implementation Ridding
- (id)init {

  self = [super init];
  if (self) {
    self.leaderUser = [[User alloc] init];
    self.map = [[Map alloc] init];
    self.aPublic=[[Public alloc]init];
  }
  return self;
}

- (id)initWithJSONDic:(NSDictionary *)jsonDic {

  self = [super init];
  if (self) {
    
    _riddingId = [[jsonDic objectForKey:@"riddingid"] longLongValue];
    _riddingStatus = [[jsonDic objectForKey:@"riddingstatus"] intValue];
    _userCount = [[jsonDic objectForKey:@"usercount"] intValue];
    
    _riddingName = [jsonDic objectForKey:@"riddingname"];
    _leaderUser = [[User alloc] initWithJSONDic:[jsonDic objectForKey:keyUser]];
    _riddingType = [[jsonDic objectForKey:@"riddingtype"] intValue];
    _createTime = [[jsonDic objectForKey:@"createtime"] longLongValue];
    _createTimeStr = [jsonDic objectForKey:@"createtimestr"];
    _lastUpdateTime = [[jsonDic objectForKey:@"lastupdatetime"] longLongValue];
    _lastUpdateTimeStr = [jsonDic objectForKey:@"lastupdatetimestr"];
    _map = [[Map alloc] initWithJSONDic:[jsonDic objectForKey:keyMap]];
    _userCount = [[jsonDic objectForKey:@"usercount"] intValue];
    _likeCount = [[jsonDic objectForKey:@"likecount"] intValue];
    _commentCount = [[jsonDic objectForKey:@"commentcount"] intValue];
    _useCount = [[jsonDic objectForKey:@"usecount"] intValue];
    _careCount = [[jsonDic objectForKey:@"carecount"] intValue];

    _nowUserLiked = [[jsonDic objectForKey:@"nowuserliked"] boolValue];
    _nowUserCared = [[jsonDic objectForKey:@"nowusercared"] boolValue];
    _nowUserUsed = [[jsonDic objectForKey:@"nowuserused"] boolValue];
    
    _aPublic=[[Public alloc]initWithJSONDic:[jsonDic objectForKey:keyPublic]];
    
    _riddingType=[[jsonDic objectForKey:@"riddingtype"] intValue];
    
    _riddingUser=[[RiddingUser alloc]initWithJSONDic:[jsonDic objectForKey:keyRiddingUser]];
    
    NSArray *array = [jsonDic objectForKey:@"riddingpictures"];
    
    if (array) {
      _riddingPictures = [[NSMutableArray alloc] init];

      for (NSDictionary *dic in array) {
        RiddingPicture *picture = [[RiddingPicture alloc] initWithJSONDic:dic];
        [_riddingPictures addObject:picture];
      }
    }
  }
  return self;
}

- (BOOL)isEnd {

  return self.riddingStatus == 10 ? FALSE : TRUE;
}

- (void)setEnd {

  self.riddingStatus = 20;
}

+ (BOOL)isLeader:(int)userRole {

  if (userRole == 20) {
    return TRUE;
  }
  return FALSE;
}
@end
