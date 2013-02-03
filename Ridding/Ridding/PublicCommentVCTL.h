//
//  PublicCommentVCTL.h
//  Ridding
//
//  Created by zys on 12-12-9.
//
//

#import "Ridding.h"
#import "HPGrowingTextView.h"
#import "PublicCommentCell.h"
#import "BasicNeedLoginViewController.h"

@interface PublicCommentVCTL : BasicNeedLoginViewController <HPGrowingTextViewDelegate, UP_EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate, UIScrollViewDelegate, PublicCommentCellDelegate> {
  UP_EGORefreshTableHeaderView *_ego;
  EGORefreshTableHeaderView *_top_Ego;
  NSMutableArray *_dataSource;
  BOOL _isLoading;
  BOOL _isLoadOld;
  BOOL _isTheEnd;
  long long _endCreateTime;
  Ridding *_ridding;
  HPGrowingTextView *_textView;
  UIImageView *_textBgView;
  UIView *_tContainerView;
  UIButton *_tSendBtn;
  long long _toUserId;
  long long _replyId;
  NSString *_beginStr;

}

@property (nonatomic, retain) IBOutlet UITableView *tv;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ridding:(Ridding *)ridding;

@end
