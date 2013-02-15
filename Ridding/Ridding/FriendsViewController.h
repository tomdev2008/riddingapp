//
//  FriendsViewController.h
//  Ridding
//
//  Created by zys on 13-2-8.
//
//

#import "BasicTableViewController.h"

@interface FriendsViewController : BasicTableViewController<UP_EGORefreshTableHeaderDelegate,EGORefreshTableHeaderDelegate>{
  UP_EGORefreshTableHeaderView *_ego;
  EGORefreshTableHeaderView *_top_Ego;
  NSMutableArray *_dataSource;
  BOOL _isLoading;
  BOOL _isLoadOld;
  BOOL _isTheEnd;
  int _lastCreateTime;
}
@end
