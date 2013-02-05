//
//  PublicCommentCell.h
//  Ridding
//
//  Created by zys on 12-12-9.
//
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@class PublicCommentCell;

@protocol PublicCommentCellDelegate <NSObject>

@optional
- (void)callBackBtnClick:(PublicCommentCell *)cell;

- (void)avatorBtnClick:(PublicCommentCell *)cell;

@end


@interface PublicCommentCell : UITableViewCell {

}
@property (nonatomic, retain) Comment *comment;
@property (nonatomic) int index;

@property (nonatomic,retain) IBOutlet UIImageView *headImageView;
@property (nonatomic,retain) IBOutlet UIButton *headImageBtn;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *descLabel;
@property (nonatomic,retain) IBOutlet UILabel *dateLabel;
@property (nonatomic,retain) IBOutlet UIButton *callBackBtn;

@property (nonatomic, assign) id <PublicCommentCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
            comment:(Comment *)comment;

+ (CGFloat)cellHeightByCommentInfo:(Comment *)comment;

- (void)initContentView;
@end
