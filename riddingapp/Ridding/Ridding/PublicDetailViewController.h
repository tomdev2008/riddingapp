//
//  PublicDetailViewController.h
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import "BasicTableViewController.h"
#import "ActivityInfo.h"
#import "TimeScroller.h"
#import "UP_EGORefreshTableHeaderView.h"
#import "PublicDetailCell.h"
#import "PublicDetailHeaderView.h"
@interface PublicDetailViewController : BasicTableViewController<UP_EGORefreshTableHeaderDelegate,PublicDetailHeaderDelegate,TimeScrollerDelegate,PublicDetailCellDelegate>{
  ActivityInfo *_info;
  TimeScroller *_timeScroller;
  UP_EGORefreshTableHeaderView *_ego;
  PublicDetailHeaderView *_headerView;
  BOOL _isEGOUpReloading;
  BOOL _isTheEnd;
  BOOL _isLoading;
  NSMutableArray *_cellArray;
  NSMutableDictionary *_contentViewCache;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil info:(ActivityInfo*)info;
@end
