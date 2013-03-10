//
//  RiddingNearByViewController.h
//  Ridding
//
//  Created by zys on 13-3-10.
//
//

#import "BasicViewController.h"
#import "QQNRFeedTableCell.h"
@interface RiddingNearByViewController : BasicViewController <QQNRFeedTableCellDelegate, UP_EGORefreshTableHeaderDelegate, UINavigationControllerDelegate,EGORefreshTableHeaderDelegate>{
  UP_EGORefreshTableHeaderView *_ego;
  EGORefreshTableHeaderView *_top_Ego;
  NSMutableArray *_dataSource;
  BOOL _isTheEnd;
  BOOL _isLoading;
  BOOL _isLoadOld;
  BOOL _isFromLeft;
  int _extOffset;
  double _latitude;
  double _longitude;
}


@property (nonatomic, retain) IBOutlet TouchEnabledTableView *tv;

@property (nonatomic, retain) IBOutlet UIImageView *lineView;
@end
