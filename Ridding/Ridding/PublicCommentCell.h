//
//  PublicCommentCell.h
//  Ridding
//
//  Created by zys on 12-12-9.
//
//

#import <UIKit/UIKit.h>
#import "Comment.h"
@interface PublicCommentCell : UITableViewCell{
  
  CGFloat _viewHeight;
  UIImageView *_headImageView;
  UILabel *_nameLabel;
  UILabel *_descLabel;
  UILabel *_dateLabel;
  UIImageView *_headLineView;
}
@property(nonatomic,retain) Comment *comment;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
            comment:(Comment*)comment;
+ (CGFloat)cellHeightByCommentInfo:(Comment *)comment;
- (void)initContentView;
@end
