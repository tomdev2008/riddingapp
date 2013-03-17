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
#define PublicDetailCellWidth 290
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

@property (nonatomic,retain) IBOutlet UIView *ibFirstView;
@property (nonatomic,retain) IBOutlet UILabel *ibDateLabel;

@property (nonatomic,retain) IBOutlet UIView *ibDetailView;
@property (nonatomic,retain) IBOutlet UIImageView *ibBgImageView;
@property (nonatomic,retain) IBOutlet UIImageView *ibImageView;

@property (nonatomic,retain) IBOutlet UIView *ibDescView;
@property (nonatomic,retain) IBOutlet UIImageView *ibAvatorView;
@property (nonatomic,retain) IBOutlet UILabel *ibDescLabel;
@property (nonatomic,retain) IBOutlet UILabel *ibLikeLabel;
@property (nonatomic,retain) IBOutlet UIButton *ibLikeBtn;
@property (nonatomic,retain) IBOutlet UIImageView *ibDescBgView;
@property (nonatomic,retain) IBOutlet UIImageView *ibLikeImageView;


- (void)initWithInfo:(RiddingPicture *)info isMyFeedHome:(BOOL)isMyFeedHome index:(int)index;

- (void)initContentView;

+ (CGFloat)heightForCell:(RiddingPicture*)info;
@end
