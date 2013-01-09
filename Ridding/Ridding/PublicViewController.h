//
//  PublicViewController.h
//  Ridding
//
//  Created by zys on 12-12-2.
//
//

#import "BasicViewController.h"
#import "UP_EGORefreshTableHeaderView.h"
#import "ActivityInfo.h"
#import "EGORefreshTableHeaderView.h"
#import "TouchEnabledTableView.h"
@interface PublicViewController : BasicViewController<UP_EGORefreshTableHeaderDelegate,UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>{
  UP_EGORefreshTableHeaderView *_ego;
  EGORefreshTableHeaderView *_top_Ego;
  NSMutableArray *_dataSource;
  BOOL _isLoading;
  BOOL _isLoadOld;
  BOOL _isTheEnd;
  long long _endUpdateTime;
  int _endWeight;
  ActivityInfoType _type;
}


@property(nonatomic, retain) IBOutlet TouchEnabledTableView *tv;
@end
