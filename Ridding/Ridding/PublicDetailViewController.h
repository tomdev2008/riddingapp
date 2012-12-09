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
#import "Photos.h"
@interface PublicDetailViewController : BasicTableViewController<UP_EGORefreshTableHeaderDelegate,PublicDetailHeaderDelegate,PublicDetailCellDelegate>{
  UP_EGORefreshTableHeaderView *_ego;
  PublicDetailHeaderView *_headerView;
  BOOL _isEGOUpReloading;
  BOOL _isTheEnd;
  BOOL _isLoading;
  NSMutableArray *_cellArray;
  Photos *_photos;
  Ridding *_ridding;
  NSArray *_localPhotos;
  NSString *_extDateStr;
  NSMutableDictionary *_cellPhotoDic;
  long long _lastUpdateTime;
}

@property (nonatomic) BOOL isMyFeedHome;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                 ridding:(Ridding*)ridding
             isMyHome:(BOOL)isMyHome;
@end
