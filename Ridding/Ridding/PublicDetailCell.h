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
#define PublicDetailCellDefaultSpace 4
#define PublicDetailCellDefaultDownSpace 10
#define PublicDetailCellOriginX 15
#define PublicDetailCellWidth 270
@class PublicDetailCell;
@protocol PublicDetailCellDelegate <NSObject>
@optional
- (void) imageViewClick:(PublicDetailCell*)view picture:(RiddingPicture*)picture imageView:(UIView *)imageView;

@end

@interface PublicDetailCell : UITableViewCell{
  UIView *_cellContentView;
  CGFloat _viewHeight;
}
@property (nonatomic,retain) RiddingPicture *info;
@property (nonatomic) int index;
@property (nonatomic, assign) id<PublicDetailCellDelegate> delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier info:(RiddingPicture*)info;
- (void)imageTap;
- (void) initContentView;
@end
