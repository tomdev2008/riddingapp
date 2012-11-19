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
@class QQNRFeedTableCell;
@protocol QQNRFeedTableCellDelegate <NSObject>
- (void)leaderTap:(ActivityInfo *)info;
- (void)statusTap:(QQNRFeedTableCell *)cell;
@end

@interface QQNRFeedTableCell : UITableViewCell{
  UIView *cellContentView;
}
@property(nonatomic,retain) ActivityInfo *info;
@property (nonatomic, assign) id<QQNRFeedTableCellDelegate> delegate;
//@property(nonatomic,retain) SWSnapshotStackView *stackView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier info:(ActivityInfo*)info;
- (CGFloat)getCellHeight;
-(UIView*)resetContentView:(BOOL)needNew;
- (void)leaderViewTap:(id)selector;
- (void)statusTap:(id)selector;
@end
