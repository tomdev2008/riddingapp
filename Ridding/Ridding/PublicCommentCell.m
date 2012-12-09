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
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, MPCommentCellDefaultSpace+_headImageView.frame.size.height, 35,20)];
    _nameLabel.font=[UIFont systemFontOfSize:9];
    _nameLabel.textColor=COLOR_BLACK;
    _nameLabel.textAlignment=UITextAlignmentCenter;
    _nameLabel.backgroundColor=[UIColor clearColor];
    _nameLabel.lineBreakMode=UILineBreakModeWordWrap;
    [self addSubview:_nameLabel];
  }
  _nameLabel.text=_comment.user.name;
  
  
  CGSize size=[_comment.text sizeWithFont:[UIFont fontWithName:@"Arial" size:12] constrainedToSize:CGSizeMake(260, 999) lineBreakMode:UILineBreakModeWordWrap];
  if(!_descLabel){
    _descLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, MPCommentCellDefaultSpace, size.width,size.height)];
    _descLabel.font=[UIFont systemFontOfSize:12];
    _descLabel.textColor=COLOR_BLACK;
    _descLabel.textAlignment=UITextAlignmentLeft;
    _descLabel.backgroundColor=[UIColor clearColor];
    _descLabel.lineBreakMode=UILineBreakModeWordWrap;
    _descLabel.numberOfLines = 0;
  }else{
    _descLabel.frame=CGRectMake(50, MPCommentCellDefaultSpace, size.width,size.height);
  }
  [self addSubview:_descLabel];
  _descLabel.text=_comment.text;
  _viewHeight+=_descLabel.frame.size.height;
  
  
  _viewHeight+=0; //间距
  if(!_dateLabel){
    _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, _viewHeight, 60, 20)];
    _dateLabel.font=[UIFont systemFontOfSize:9];
    _dateLabel.textColor=COLOR_GRAY;
    _dateLabel.backgroundColor=[UIColor clearColor];
    _dateLabel.textAlignment=UITextAlignmentLeft;
    [self addSubview:_dateLabel];
  }else{
    _dateLabel.frame=CGRectMake(50, _viewHeight, 60, 20);
  }
  _dateLabel.text=_comment.beforeTime;
  _viewHeight+=_dateLabel.frame.size.height;
  
  _viewHeight+=5; //间距
}


+ (CGFloat)cellHeightByCommentInfo:(Comment *)comment {
  
  CGFloat viewHeight=MPCommentCellDefaultSpace;
  
   CGSize size=[comment.text sizeWithFont:[UIFont fontWithName:@"Arial" size:13] constrainedToSize:CGSizeMake(50, 999) lineBreakMode:UILineBreakModeWordWrap];
  viewHeight+=size.height;

  viewHeight+=20; //日期
  viewHeight+=5; //间距
  
  if(viewHeight<60){
    return 60;
  }
  
  return viewHeight;
}

@end
