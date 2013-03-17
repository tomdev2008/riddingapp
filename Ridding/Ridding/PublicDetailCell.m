//
//  PublicDetailCellViewCell.m
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import "PublicDetailCell.h"
#import "UIImageView+WebCache.h"
#import "QiNiuUtils.h"
#import "UIColor+XMin.h"
#import "UILabel+Addition.h"
#define DefaultPublicDetailtDetailView 35
#define DefaultPublicDetailtFirstView 5
#define DefaultPublicDetailDescLabelWidth 205
#define DefaultPublicDetailDescLabelSize 12
@interface PublicDetailCell () {
  
}
@end

@implementation PublicDetailCell

- (void)initWithInfo:(RiddingPicture *)info isMyFeedHome:(BOOL)isMyFeedHome index:(int)index{
  
  self.info = info;
  _isMyFeedHome = isMyFeedHome;
  self.index=index;
  [self initContentView];
}


- (void)awakeFromNib{
  [super awakeFromNib];
  [_ibDescLabel alignTop];
//  _imageView.layer.borderColor=[[UIColor getColor:@"747474"]CGColor];
//  _imageView.layer.borderWidth=1.0;
  _ibDescLabel.numberOfLines=0;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
  [_ibImageView addGestureRecognizer:tap];
}

- (void)initContentView {

  CGRect frame=_ibDetailView.frame;
  if (_info.isFirstPic) {
    
    _ibFirstView.hidden=NO;
    _ibDateLabel.text=_info.takePicDateStr;
    frame.origin.y=DefaultPublicDetailtDetailView;
    
  } else {
    frame.origin.y=DefaultPublicDetailtFirstView;
    _ibFirstView.hidden=YES;
  }

  CGFloat width = PublicDetailCellWidth;
  CGFloat height;
  if (self.info.width == 0 || self.info.height == 0) {
    height = PublicDetailCellWidth;
  } else if (self.info.width / self.info.height > 1) {
    height = self.info.height * 1.0 / self.info.width * width;
  } else {
    height = self.info.height * 1.0 / self.info.width * width;
  }
  
  frame.size.height=height;
  _ibDetailView.frame=frame;
  NSURL *url = [QiNiuUtils getUrlBySizeToUrl:_ibImageView.frame.size url:_info.photoUrl type:QINIUMODE_DEDEFAULT];
  [_ibImageView setImageWithURL:url placeholderImage:nil];
  _ibBgImageView.image=[UIIMAGE_FROMPNG(@"qqnr_pd_picbg") stretchableImageWithLeftCapWidth:50 topCapHeight:50];


  NSString *desc = self.info.pictureDescription;
  CGSize linesSz = [desc sizeWithFont:[UIFont boldSystemFontOfSize:DefaultPublicDetailDescLabelSize] constrainedToSize:CGSizeMake(DefaultPublicDetailDescLabelWidth, MAXFLOAT) lineBreakMode:(NSLineBreakMode) UILineBreakModeCharacterWrap];
  
  frame=_ibDescView.frame;
  if(linesSz.height>12){
    frame.size.height=MIN(40+linesSz.height-12,80);
    frame.origin.y= _ibDetailView.frame.size.height-12-frame.size.height;
    
  }else{
    frame.size.height=40;
    frame.origin.y=_ibDetailView.frame.size.height-12-frame.size.height;
    
  }
  _ibDescView.frame=frame;
  _ibDescBgView.image=[UIIMAGE_FROMPNG(@"qqnr_pd_descbg") stretchableImageWithLeftCapWidth:20 topCapHeight:10];
  
  
  url=[QiNiuUtils getUrlBySizeToUrl:_ibAvatorView.frame.size url:self.info.user.savatorUrl type:QINIUMODE_DESHORT];
  [_ibAvatorView setImageWithURL:url placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];
  
  _ibDescLabel.text=desc;
  
  if(!_isMyFeedHome){
    _ibLikeLabel.hidden=NO;
    _ibLikeImageView.hidden=NO;
    
    if(self.info.likeCount>100){
      _ibLikeLabel.text = @"N";
    }else{
      _ibLikeLabel.text = INT2STR(self.info.likeCount);
    }
    if (self.info.liked) {
      _ibLikeImageView.image=UIIMAGE_FROMPNG(@"qqnr_pd_likedpic");
      _ibLikeBtn.enabled=NO;
    } else {
      _ibLikeImageView.image=UIIMAGE_FROMPNG(@"qqnr_pd_likepic");
      _ibLikeBtn.enabled=YES;
    }
  }else{
    _ibLikeLabel.hidden=YES;
    _ibLikeImageView.hidden=YES;
  }

}


- (IBAction)likeBtnClick:(id)sender {

  BOOL succ = false;
  if (self.delegate) {
    succ = [self.delegate likeBtnClick:self picture:self.info];
  }
  if (succ) {
    self.info.liked = TRUE;
    _ibLikeBtn.enabled=NO;
    _ibLikeImageView.image=UIIMAGE_FROMPNG(@"qqnr_pd_likedpic") ;
    self.info.likeCount += 1;
    _ibLikeLabel.text = INT2STR(self.info.likeCount);
  }

}

- (void)showDeleteAction:(UIGestureRecognizer *)gestureRecognizer  {

  if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    if (self.delegate){
      [self.delegate deletePicture:self index:_index];
    }
  }

}

- (void)imageViewTap:(UIGestureRecognizer *)gesture {

  UIImageView *imageView = (UIImageView *) gesture.view;
  if (self.delegate) {
    [self.delegate imageViewClick:self picture:self.info imageView:imageView];
  }
}


+ (CGFloat)heightForCell:(RiddingPicture*)info{
  
  CGFloat defaultHeight=0;
  if (info.isFirstPic) {
    
    defaultHeight=35;
  }else{
    
    defaultHeight=5;
  }
  CGFloat width = PublicDetailCellWidth;
  CGFloat height;
  if (info.width == 0 || info.height == 0) {
    height = PublicDetailCellWidth;
  } else if (info.width / info.height > 1) {
    height = info.height * 1.0 / info.width * width;
  } else {
    height = info.height * 1.0 / info.width * width;
  }
  defaultHeight+=height+12;
  defaultHeight+=10;
  return defaultHeight;
}
@end
