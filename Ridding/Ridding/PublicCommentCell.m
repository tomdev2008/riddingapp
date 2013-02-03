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
#define MPCommentCellDefaultSpace 10.0f

@implementation PublicCommentCell
@synthesize comment = _comment;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
            comment:(Comment *)comment {

  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _comment = comment;
  }
  return self;

}

- (void)initContentView {

  _viewHeight = MPCommentCellDefaultSpace;
  

  if (!_headImageView) {
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, MPCommentCellDefaultSpace, 46, 46)];
    _headImageView.image=UIIMAGE_FROMPNG(@"qqnr_pd_comment_photo_bg");
    [self addSubview:_headImageView];
  }
  
  if (!_headImageBtn){
    _headImageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_headImageBtn addTarget:self action:@selector(avatorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_headImageBtn];
  }
  _headImageBtn.frame=CGRectMake(18, MPCommentCellDefaultSpace+3, 36, 36);
    NSURL *headerUrl = [QiNiuUtils getUrlBySizeToUrl:_headImageView.frame.size url:_comment.user.savatorUrl type:QINIUMODE_DEDEFAULT];
  [_headImageBtn setImageWithURL:headerUrl placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];

  if (!_headIconView){
    _headIconView=[[UIImageView alloc]initWithFrame:CGRectMake(70, MPCommentCellDefaultSpace, 12, 12)];
    _headIconView.image=UIIMAGE_FROMPNG(@"qqnr_pd_comment_icon_visitor");
    [self addSubview:_headIconView];
  }

  if (!_nameLabel) {
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, MPCommentCellDefaultSpace, 70, 12)];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.textColor = [UIColor getColor:ColorTextColor];
    _nameLabel.textAlignment = UITextAlignmentLeft;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.lineBreakMode = UILineBreakModeWordWrap;
    [self addSubview:_nameLabel];
  }
  _nameLabel.text = _comment.user.name;

  if (!_timeImageView){
    _timeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(160, MPCommentCellDefaultSpace, 12, 12)];
    _timeImageView.image=UIIMAGE_FROMPNG(@"qqnr_pd_comment_icon_time");
    [self addSubview:_timeImageView];
  }
  
  if (!_dateLabel) {
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, MPCommentCellDefaultSpace, 60, 12)];
    _dateLabel.font = [UIFont systemFontOfSize:12];
    _dateLabel.textColor = [UIColor getColor:ColorTextColor];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textAlignment = UITextAlignmentLeft;
    [self addSubview:_dateLabel];
  } 
  _dateLabel.text = _comment.beforeTime;
  
  CGSize size = [_comment.text sizeWithFont:[UIFont fontWithName:@"Arial" size:12] constrainedToSize:CGSizeMake(210, 999) lineBreakMode:UILineBreakModeWordWrap];
  if (!_descLabel) {
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, MPCommentCellDefaultSpace + 20, size.width, size.height)];
    _descLabel.font = [UIFont systemFontOfSize:12];
    _descLabel.textColor = [UIColor getColor:ColorTextColor];
    _descLabel.textAlignment = UITextAlignmentLeft;
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.lineBreakMode = UILineBreakModeWordWrap;
    _descLabel.numberOfLines = 0;
  } else {
    _descLabel.frame = CGRectMake(70, MPCommentCellDefaultSpace + 20, size.width, size.height);
  }
  [self addSubview:_descLabel];
  _descLabel.text = _comment.text;
  
  if (!_callBackBtn) {
    _callBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _callBackBtn.frame = CGRectMake(290, MPCommentCellDefaultSpace + 20, 20, 20);
    _callBackBtn.showsTouchWhenHighlighted=YES;
    [_callBackBtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_comment_reply") forState:UIControlStateNormal];
    [_callBackBtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_comment_reply_hl") forState:UIControlStateHighlighted];
    [_callBackBtn addTarget:self action:@selector(callBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_callBackBtn];
  }
  
  _viewHeight+=20;
  
  if (_descLabel.frame.size.height < 20) {
    _viewHeight += 20;
  } else {
    _viewHeight += _descLabel.frame.size.height;
  }
  
  if(!_lineImageView){
    _lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, _viewHeight+8, self.frame.size.width, 2)];
    _lineImageView.image=[UIIMAGE_FROMPNG(@"qqnr_pd_comment_line") stretchableImageWithLeftCapWidth:17 topCapHeight:0];
    [self addSubview:_lineImageView];
  }else{
    _lineImageView.frame=CGRectMake(0, _viewHeight+8, self.frame.size.width, 2);
  }
  
  _viewHeight += 10; //间距
  
}

- (void)callBackBtnClick:(id)sender {

  if (self.delegate) {
    [self.delegate callBackBtnClick:self];
  }
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

- (void)avatorBtnClick:(id)sender{
  if(self.delegate){
    [self.delegate avatorBtnClick:self];
  }
}

@end
