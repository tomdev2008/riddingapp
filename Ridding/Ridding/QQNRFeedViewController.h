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
@interface QQNRFeedViewController : BasicTableViewController<QQNRFeedTableCellDelegate,TimeScrollerDelegate,UP_EGORefreshTableHeaderDelegate,QQNRFeedHeaderViewDelegate,UIActionSheetDelegate,AwesomeMenuDelegate,MapCreateVCTLDelegate,MapCreateDescVCTLDelegate>{
  NSString *_latestCreateTime;
  NSString *_endCreateTime;
  NSMutableArray *_activities;
  TimeScroller *_timeScroller;
  UP_EGORefreshTableHeaderView *_ego;
  BOOL _isEGOUpReloading;
  BOOL _isTheEnd;
  User *_exUser;
  User *_nowUser;
  NSMutableDictionary *_cellCache;
  QQNRFeedHeaderView *_FHV;
  QQNRFeedTableCell *_selectedCell;
  BOOL _isShowingSheet;
  BOOL _isLoading;
  BOOL _isLoadOld;
  AwesomeMenu *_menu;
}

@property (nonatomic) BOOL isMyFeedHome;


- (id)initWithUser:(User*)nowUser exUser:(User*)exUser;
-(IBAction)initBtnPress:(id)sender;

@end
