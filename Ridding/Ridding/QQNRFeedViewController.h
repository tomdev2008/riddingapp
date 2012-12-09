//
//  QQNRFeedViewController.h
//  Ridding
//
//  Created by zys on 12-9-27.
//
//

#import "BasicTableViewController.h"
#import "QQNRFeedTableCell.h"
#import "User.h"
#import "TimeScroller.h"
#import "EGORefreshTableHeaderView.h"
#import "QQNRFeedHeaderView.h"
#import "AwesomeMenu.h"
#import "MapCreateVCTL.h"
#import "MapCreateDescVCTL.h"
#import "EGORefreshTableHeaderView.h"
@interface QQNRFeedViewController : BasicTableViewController<QQNRFeedTableCellDelegate,TimeScrollerDelegate,UP_EGORefreshTableHeaderDelegate,QQNRFeedHeaderViewDelegate,UIActionSheetDelegate,AwesomeMenuDelegate,MapCreateVCTLDelegate,MapCreateDescVCTLDelegate>{
  long long _endCreateTime;
  NSMutableArray *_dataSource;
  TimeScroller *_timeScroller;
  UP_EGORefreshTableHeaderView *_ego;
  User *_exUser;
  User *_nowUser;
  QQNRFeedHeaderView *_FHV;
  QQNRFeedTableCell *_selectedCell;
  BOOL _isShowingSheet;
  BOOL _isTheEnd;
  BOOL _isLoading;
  BOOL _isLoadOld;
  AwesomeMenu *_menu;
}

@property (nonatomic) BOOL isMyFeedHome;


- (id)initWithUser:(User*)nowUser exUser:(User*)exUser;
-(IBAction)initBtnPress:(id)sender;

@end
