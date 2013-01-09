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
#import "MapCreateVCTL.h"
#import "MapCreateDescVCTL.h"
#import "EGORefreshTableHeaderView.h"
@interface QQNRFeedViewController : BasicTableViewController<QQNRFeedTableCellDelegate,TimeScrollerDelegate,UP_EGORefreshTableHeaderDelegate,QQNRFeedHeaderViewDelegate,UIActionSheetDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
  long long _endCreateTime;
  NSMutableArray *_dataSource;
 // TimeScroller *_timeScroller;
  UP_EGORefreshTableHeaderView *_ego;
  User *_toUser;
  QQNRFeedHeaderView *_FHV;
  QQNRFeedTableCell *_selectedCell;
  UIImageView *_backgroundImageView;
  BOOL _isShowingSheet;
  BOOL _isTheEnd;
  BOOL _isLoading;
  BOOL _isLoadOld;
  BOOL _isFromLeft;
  CGFloat _preHeight;
}

@property (nonatomic) BOOL isMyFeedHome;


- (id)initWithUser:(User*)toUser isFromLeft:(BOOL)isFromLeft;
-(IBAction)initBtnPress:(id)sender;

@end
