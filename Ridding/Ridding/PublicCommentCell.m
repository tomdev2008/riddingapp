//
//  PublicCommentCell.m
//  Ridding
//
//  Created by zys on 12-12-9.
//
//

#import "PublicCommentCell.h"
#import "QiNiuUtils.h"
#import "UIButton+WebCache.h"
#import "UIColor+XMin.h"
#import "UILabel+Addition.h"
#define MPCommentCellDefaultSpace 10.0f

@implementation PublicCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
            comment:(Comment *)comment {

  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _comment = comment;
  }
  return self;

}

- (void)awakeFromNib{
  
  _nameLabel.textColor = [UIColor getColor:ColorTextColor];
  _nameLabel.lineBreakMode = UILineBreakModeWordWrap;
  [_dateLabel alignTop];
  _dateLabel.textColor = [UIColor getColor:ColorTextColor];

  [_callBackBtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_comment_reply") forState:UIControlStateNormal];
  [_callBackBtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_comment_reply_hl") forState:UIControlStateHighlighted];
  
  _descLabel.textColor = [UIColor getColor:ColorTextColor];
 
  _descLabel.lineBreakMode = UILineBreakModeWordWrap;
  _descLabel.numberOfLines = 0;
  
  _separatorLine.image=[UIIMAGE_FROMPNG(@"qqnr_pd_comment_line") stretchableImageWithLeftCapWidth:17 topCapHeight:0];


  [super awakeFromNib];
}

- (void)initContentView {

  NSURL *headerUrl = [QiNiuUtils getUrlBySizeToUrl:_headImageView.frame.size url:_comment.user.savatorUrl type:QINIUMODE_DEDEFAULT];
  [_headImageBtn setImageWithURL:headerUrl placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];
  
  _nameLabel.text = _comment.user.name;
  _dateLabel.text = _comment.beforeTime;
  
  CGSize size = [_comment.text sizeWithFont:[UIFont fontWithName:@"Arial" size:12] constrainedToSize:CGSizeMake(210, 999) lineBreakMode:UILineBreakModeWordWrap];
  CGFloat height=20;
  if(size.height>20){
    height=size.height;
  }
   _descLabel.frame = CGRectMake(_descLabel.frame.origin.x, _descLabel.frame.origin.y, _descLabel.frame.size.width, height);
  _descLabel.text = _comment.text;
  
}

+ (CGFloat)cellHeightByCommentInfo:(Comment *)comment {

  CGFloat viewHeight = MPCommentCellDefaultSpace;

  viewHeight+=20;
  
  CGSize size = [comment.text sizeWithFont:[UIFont fontWithName:@"Arial" size:12] constrainedToSize:CGSizeMake(210, 999) lineBreakMode:UILineBreakModeWordWrap];
  if (size.height < 20) {
    viewHeight += 20;
  } else {
    viewHeight += size.height;
  }

  viewHeight += 10; //日期

  return viewHeight;
}

- (IBAction)callBackBtnClick:(id)sender {
  
  if (self.delegate) {
    [self.delegate callBackBtnClick:self];
  }
}

- (IBAction)avatorBtnClick:(id)sender {
  if(self.delegate){
    [self.delegate avatorBtnClick:self];
  }
}

@end
