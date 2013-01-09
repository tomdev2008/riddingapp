//
//  PublicCommentCell.m
//  Ridding
//
//  Created by zys on 12-12-9.
//
//

#import "PublicCommentCell.h"
#import "Comment.h"
#import "QiNiuUtils.h"
#import "UIImageView+WebCache.h"
#define MPCommentCellDefaultSpace 10.0f
@implementation PublicCommentCell
@synthesize comment=_comment;
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
            comment:(Comment*)comment{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _comment=comment;
  }
  return self;
  
}

- (void)initContentView{
  _viewHeight=MPCommentCellDefaultSpace;
  
  if(!_headImageView){
    _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, MPCommentCellDefaultSpace, 35, 35)];
    [self addSubview:_headImageView];
  }
  NSURL *headerUrl=[QiNiuUtils getUrlBySizeToUrl:_headImageView.frame.size url:_comment.user.savatorUrl type:QINIUMODE_DEDEFAULT];
  [_headImageView setImageWithURL:headerUrl placeholderImage:UIIMAGE_FROMPNG(@"duser")];
  
 
  if(!_nameLabel){
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, MPCommentCellDefaultSpace+_headImageView.frame.size.height, 45,20)];
    _nameLabel.font=[UIFont systemFontOfSize:9];
    _nameLabel.textColor=COLOR_BLACK;
    _nameLabel.textAlignment=UITextAlignmentCenter;
    _nameLabel.backgroundColor=[UIColor clearColor];
    _nameLabel.lineBreakMode=UILineBreakModeWordWrap;
    [self addSubview:_nameLabel];
  }
  _nameLabel.text=_comment.user.name;
  
  
  CGSize size=[_comment.text sizeWithFont:[UIFont fontWithName:@"Arial" size:14] constrainedToSize:CGSizeMake(240, 999) lineBreakMode:UILineBreakModeWordWrap];
  if(!_descLabel){
    _descLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, MPCommentCellDefaultSpace, size.width,size.height)];
    _descLabel.font=[UIFont systemFontOfSize:14];
    _descLabel.textColor=COLOR_BLACK;
    _descLabel.textAlignment=UITextAlignmentLeft;
    _descLabel.backgroundColor=[UIColor clearColor];
    _descLabel.lineBreakMode=UILineBreakModeWordWrap;
    _descLabel.numberOfLines = 0;
  }else{
    _descLabel.frame=CGRectMake(60, MPCommentCellDefaultSpace, size.width,size.height);
  }
  [self addSubview:_descLabel];
  _descLabel.text=_comment.text;
  if(_descLabel.frame.size.height<35){
    _viewHeight+=35;
  }else{
    _viewHeight+=_descLabel.frame.size.height;
  }
  
  
  
  _viewHeight+=0; //间距
  if(!_dateLabel){
    _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, _viewHeight, 60, 20)];
    _dateLabel.font=[UIFont systemFontOfSize:10];
    _dateLabel.textColor=COLOR_GRAY;
    _dateLabel.backgroundColor=[UIColor clearColor];
    _dateLabel.textAlignment=UITextAlignmentLeft;
    [self addSubview:_dateLabel];
  }else{
    _dateLabel.frame=CGRectMake(60, _viewHeight, 60, 20);
  }
  _dateLabel.text=_comment.beforeTime;
  
  if(!_callBackBtn){
    _callBackBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _callBackBtn.frame=CGRectMake(270, _viewHeight, 60, 20);
    [_callBackBtn setTitle:@"回复" forState:UIControlStateNormal];
    [_callBackBtn setTitle:@"回复" forState:UIControlStateHighlighted];
    [_callBackBtn setTitleColor:COLOR_GRAY forState:UIControlStateNormal];
    [_callBackBtn setTitleColor:COLOR_GRAY forState:UIControlStateHighlighted];
    [_callBackBtn addTarget:self action:@selector(callBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_callBackBtn];
  }else{
    _callBackBtn.frame=CGRectMake(270, _viewHeight, 60, 20);
  }
  
  _viewHeight+=_dateLabel.frame.size.height;
  
  _viewHeight+=5; //间距
}
- (void)callBackBtnClick:(id)sender{
  if(self.delegate){
    [self.delegate callBackBtnClick:self];
  }
}


+ (CGFloat)cellHeightByCommentInfo:(Comment *)comment {
  
  CGFloat viewHeight=MPCommentCellDefaultSpace;
  
  CGSize size=[comment.text sizeWithFont:[UIFont fontWithName:@"Arial" size:14] constrainedToSize:CGSizeMake(240, 999) lineBreakMode:UILineBreakModeWordWrap];
  if(size.height<35){
    viewHeight+=35;
  }else{
    viewHeight+=size.height;
  }

  viewHeight+=20; //日期
  viewHeight+=5; //间距
  
  if(viewHeight<60){
    return 60;
  }
  
  return viewHeight;
}

@end
