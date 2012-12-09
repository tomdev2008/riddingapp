//
//  PublicDetailCellViewCell.m
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import "PublicDetailCell.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "UIImage+Utilities.h"
#import "QiNiuUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+XMin.h"

@interface PublicDetailCell (){
  UILabel *_descLabel;
  UILabel *_timeLabel;
  UIImageView *_imageView;
  UIImageView *_jtImageView;
  UIImageView *_avatorImageView;
  UIImageView *_timeImageView;
  UILabel *_locationLabel;
  UILabel *_dateLabel;
  UIImageView *_beginImageView;
}
@end
@implementation PublicDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier info:(RiddingPicture*)info
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.info=info;


  }
  return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}

- (void)imageTap{
  
}

- (void) initContentView{
  _viewHeight=PublicDetailCellDefaultSpace;
  [_dateLabel removeFromSuperview];
  [_beginImageView removeFromSuperview];
//  if(_index==0){
//    if(!_beginImageView){
//      _beginImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, _viewHeight-5, 20, 30)];
//      _beginImageView.image=UIIMAGE_FROMPNG(@"起点图标");
//    }
//    [self addSubview:_beginImageView];
//  }
  
//  if(_info.isFirstPic){
//    if(!_dateLabel){
//      _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, _viewHeight, 230, 20)];
//      _dateLabel.backgroundColor=[UIColor clearColor];
//      _dateLabel.lineBreakMode = UILineBreakModeWordWrap;
//      _dateLabel.numberOfLines = 0;
//      _dateLabel.textColor=[UIColor getColor:ColorOrange];
//      _dateLabel.textAlignment=UITextAlignmentLeft;
//      _dateLabel.font=[UIFont boldSystemFontOfSize:14];
//    }else{
//      _dateLabel.frame=CGRectMake(60, _viewHeight, 230, 20);
//    }
//    _dateLabel.text=_info.takePicDate;
//    [self addSubview:_dateLabel];
//    _viewHeight+=_dateLabel.frame.size.height;
//    _viewHeight+=5;
//  }
  
  [self inputStackView];

  if(!_jtImageView){
    _jtImageView=[[UIImageView alloc]initWithFrame:CGRectMake(PublicDetailCellOriginX, _viewHeight, PublicDetailCellWidth, 16)];
    _jtImageView.image=[UIIMAGE_FROMPNG(@"pj_jt") stretchableImageWithLeftCapWidth:0 topCapHeight:11];
    [self addSubview:_jtImageView];
  }else{
    _jtImageView.frame=CGRectMake(PublicDetailCellOriginX, _viewHeight, PublicDetailCellWidth, 16);
  }
  _viewHeight+=16;
  
  if(!_avatorImageView){
    _avatorImageView=[[UIImageView alloc]initWithFrame:CGRectMake(PublicDetailCellOriginX+5, _viewHeight, 35, 35)];
    [self addSubview:_avatorImageView];
  }else{
    _avatorImageView.frame=CGRectMake(PublicDetailCellOriginX+5, _viewHeight, 35, 35);
  }
  NSURL *url=[QiNiuUtils getUrlBySizeToUrl:_avatorImageView.frame.size url:_info.user.savatorUrl type:QINIUMODE_DESHORT];
  [_avatorImageView setImageWithURL:url placeholderImage:UIIMAGE_FROMPNG(@"duser")];
  
  if(!_descLabel){
    _descLabel=[[UILabel alloc]initWithFrame:CGRectMake(65, _viewHeight, 225, 20)];
    _descLabel.backgroundColor=[UIColor clearColor];
    _descLabel.lineBreakMode = UILineBreakModeWordWrap;
    _descLabel.numberOfLines = 0;
    _descLabel.textColor=COLOR_GRAY;
    _descLabel.textAlignment=UITextAlignmentLeft;
    _descLabel.font=[UIFont systemFontOfSize:14];
    [self addSubview:_descLabel];
  }else{
    _descLabel.frame=CGRectMake(65, _viewHeight, 225, 20);
  }
  _descLabel.text=_info.pictureDescription;
  CGSize linesSz = [_descLabel.text sizeWithFont:_descLabel.font constrainedToSize:CGSizeMake(_descLabel.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
  _viewHeight+=linesSz.height;
  _viewHeight+=5;

  if(!_timeImageView){
    _timeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(65, _viewHeight+4, 12, 12)];
    _timeImageView.image=UIIMAGE_FROMPNG(@"time");
    [self addSubview:_timeImageView];
  }else{
    _timeImageView.frame=CGRectMake(65, _viewHeight+4, 12, 12);
  }
  
  if(!_locationLabel){
    _locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(205, _viewHeight, 75, 20)];
    _locationLabel.backgroundColor=[UIColor clearColor];
    _locationLabel.lineBreakMode = UILineBreakModeWordWrap;
    _locationLabel.numberOfLines = 0;
    _locationLabel.textColor=[UIColor getColor:ColorBlue];
    _locationLabel.textAlignment=UITextAlignmentRight;
    _locationLabel.font=[UIFont systemFontOfSize:12];
    [self addSubview:_locationLabel];
  }else{
    _locationLabel.frame=CGRectMake(205, _viewHeight, 75, 20);
  }
   _locationLabel.text=_info.location;
  
  if(!_timeLabel){
   
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, _viewHeight, 120, 20)];
    _timeLabel.backgroundColor=[UIColor clearColor];
    _timeLabel.lineBreakMode = UILineBreakModeWordWrap;
    _timeLabel.numberOfLines = 0;
    _timeLabel.textColor=COLOR_GRAY;
    _timeLabel.textAlignment=UITextAlignmentLeft;
    _timeLabel.font=[UIFont systemFontOfSize:12];
    [self addSubview:_timeLabel];
  }else{
    _timeLabel.frame=CGRectMake(80, _viewHeight, 120, 20);
  }
  _timeLabel.text=_info.takePicDateStr;
   linesSz = [_timeLabel.text sizeWithFont:_timeLabel.font constrainedToSize:CGSizeMake(_timeLabel.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
  _viewHeight+=linesSz.height;
  _viewHeight+=5;
  
  //这里需要再设置jtimageVIew
  CGRect frame=_jtImageView.frame;
  frame.size.height=_viewHeight-frame.origin.y;
  _jtImageView.frame=frame;
  

  _viewHeight+=PublicDetailCellDefaultDownSpace;
}

- (void) inputStackView{
  CGFloat width=PublicDetailCellWidth;
  CGFloat height;
  if(self.info.width==0||self.info.height==0){
    height=PublicDetailCellWidth;
  }else if(self.info.width/self.info.height>1){
    height=self.info.height*1.0/self.info.width*width;
  }else{
    height=self.info.height*1.0/self.info.width*width;
  }
  
  if(!_imageView){
    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(PublicDetailCellOriginX, _viewHeight, width, height)];
    _imageView.backgroundColor=[UIColor clearColor];
    _imageView.layer.borderColor=[[UIColor whiteColor]CGColor];
    _imageView.layer.borderWidth=2;
    [self addSubview:_imageView];
  }else{
    _imageView.frame=CGRectMake(PublicDetailCellOriginX, _viewHeight, width, height);
    _imageView.image=nil;
  }
  NSURL *url=[QiNiuUtils getUrlBySizeToUrl:_imageView.frame.size url:_info.photoUrl type:QINIUMODE_DESHORT];
  [_imageView setImageWithURL:url placeholderImage:nil];
  
  _viewHeight+=height;
}

@end
