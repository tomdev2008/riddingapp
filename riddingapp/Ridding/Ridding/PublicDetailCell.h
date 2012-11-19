//
//  PublicDetailCellViewCell.h
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import <UIKit/UIKit.h>
#import "ActivityInfo.h"
#import "SWSnapshotStackView.h"
#import "RiddingPicture.h"
#import "PublicDetailDescView.h"
@class PublicDetailCell;
@protocol PublicDetailCellDelegate <NSObject>
@optional
- (void)tapBigImageView:(PublicDetailCell *)cell;

@end

@interface PublicDetailCell : UITableViewCell{
  UIView *_cellContentView;
}
@property(nonatomic,retain) RiddingPicture *info;
@property (nonatomic, assign) id<PublicDetailCellDelegate> delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier info:(RiddingPicture*)info;
-(UIView*)resetContentView;
- (NSInteger)getCellHeight;
- (void)imageTap;
@end
