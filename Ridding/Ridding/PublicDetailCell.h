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
#define PublicDetailCellOriginX 20
#define PublicDetailCellWidth 280
@class PublicDetailCell;

@protocol PublicDetailCellDelegate <NSObject>
@optional
- (void)imageViewClick:(PublicDetailCell *)view picture:(RiddingPicture *)picture imageView:(UIView *)imageView;

- (BOOL)likeBtnClick:(PublicDetailCell *)view picture:(RiddingPicture *)picture;

- (void)deletePicture:(PublicDetailCell *)view index:(int)index;

@end

@interface PublicDetailCell : UITableViewCell {
  UIView *_cellContentView;
  CGFloat _viewHeight;
  BOOL _isMyFeedHome;
}
@property (nonatomic, retain) RiddingPicture *info;
@property (nonatomic) int index;
@property (nonatomic, assign) id <PublicDetailCellDelegate> delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier info:(RiddingPicture *)info isMyFeedHome:(BOOL)isMyFeedHome;

- (void)imageTap;

- (void)initContentView;
@end
