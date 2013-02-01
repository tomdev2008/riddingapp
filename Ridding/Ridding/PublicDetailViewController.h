//
//  PublicDetailViewController.h
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import "BasicNeedLoginViewController.h"
#import "ActivityInfo.h"
#import "UP_EGORefreshTableHeaderView.h"
#import "PublicDetailCell.h"
#import "PublicDetailHeaderView.h"
#import "QQNRSourceLoginViewController.h"

@interface PublicDetailViewController : BasicNeedLoginViewController <UP_EGORefreshTableHeaderDelegate, PublicDetailHeaderDelegate, PublicDetailCellDelegate, RiddingViewControllerDelegate, QQNRSourceLoginViewControllerDelegate> {
  UP_EGORefreshTableHeaderView *_ego;
  PublicDetailHeaderView *_headerView;
  BOOL _isTheEnd;
  BOOL _isLoading;
  NSMutableArray *_cellArray;
  Ridding *_ridding;
  NSArray *_localPhotos;
  NSString *_extDateStr;
  long long _lastUpdateTime;
  BOOL _isMyFeedHome;
  User *_toUser;
  UIButton *_useBtn;
  UIButton *_careBtn;
  UIButton *_commentBtn;

}

@property (nonatomic) BOOL isMyFeedHome;
@property (nonatomic, retain) IBOutlet UITableView *tv;


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
              ridding:(Ridding *)ridding
             isMyHome:(BOOL)isMyHome
               toUser:(User *)toUser;
@end
