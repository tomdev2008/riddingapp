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
#import "EGORefreshTableHeaderView.h"
#import "QQNRFeedHeaderView.h"
#import "MapCreateVCTL.h"
#import "MapCreateDescVCTL.h"
#import "EGORefreshTableHeaderView.h"
#import "GADSearchBannerView.h"
#import "GADSearchRequest.h"

@interface QQNRFeedViewController : BasicViewController <QQNRFeedTableCellDelegate, UP_EGORefreshTableHeaderDelegate, QQNRFeedHeaderViewDelegate, UIActionSheetDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate,GADBannerViewDelegate> {
  long long _endCreateTime;
  NSMutableArray *_dataSource;
  UP_EGORefreshTableHeaderView *_ego;
  User *_toUser;
  QQNRFeedHeaderView *_FHV;
  QQNRFeedTableCell *_selectedCell;
  UIImageView *_backgroundImageView;
  BOOL _isTheEnd;
  BOOL _isLoading;
  BOOL _isLoadOld;
  BOOL _isFromLeft;
  CGFloat _preHeight;
  GADSearchBannerView *_bannerView;
}

@property (nonatomic, retain) IBOutlet TouchEnabledTableView *tv;

@property (nonatomic, retain) IBOutlet UIImageView *lineView;
@property (nonatomic, retain) IBOutlet UIView *nothingView;
@property (nonatomic) BOOL isMyFeedHome;


- (id)initWithUser:(User *)toUser isFromLeft:(BOOL)isFromLeft;

- (IBAction)initBtnPress:(id)sender;

@end
