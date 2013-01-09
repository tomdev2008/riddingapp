//
//  QQNRFeedTableCell.h
//  Ridding
//
//  Created by zys on 12-9-27.
//
//

#import <UIKit/UIKit.h>
#include "ActivityInfo.h"
#import "SWSnapshotStackView.h"
#import "DetailTextView.h"
@class QQNRFeedTableCell;
@protocol QQNRFeedTableCellDelegate <NSObject>
- (void)leaderTap:(ActivityInfo *)info;
- (void)statusTap:(QQNRFeedTableCell *)cell;
@end

@interface QQNRFeedTableCell : UITableViewCell{
}


@property(nonatomic,retain) Ridding *ridding;
@property (nonatomic, assign) id<QQNRFeedTableCellDelegate> delegate;


@property(nonatomic,retain) IBOutlet UIButton *avatorBtn;
@property(nonatomic,retain) IBOutlet DetailTextView *nameLabel;
@property(nonatomic,retain) IBOutlet DetailTextView *teamCountLabel;
@property(nonatomic,retain) IBOutlet DetailTextView *distanceLabel;
@property(nonatomic,retain) IBOutlet DetailTextView *beginLocationLabel;
@property(nonatomic,retain) IBOutlet DetailTextView *endLocationLabel;
@property(nonatomic,retain) IBOutlet UILabel *statusLabel;
@property(nonatomic,retain) IBOutlet UIImageView *mapImageView;

- (void)initContentView;

@end
