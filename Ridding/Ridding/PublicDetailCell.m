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
@interface PublicDetailCell () {
  UILabel *_dateLabel;
  UIImageView *_imageView;
  UIImageView *_imageBGView;
  UIImageView *_beginImageView;
  UIImageView *_imageViewDescBG;
  UILabel *_descLabel;
  UIView *_imageViewDescView;
  UIButton *_likeBtn;
  UILabel *_likeCountLabel;
  UIView *_likeClickView;
  UIImageView *_avatorImageView;
}
@end

@implementation PublicDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier info:(RiddingPicture *)info   isMyFeedHome:(BOOL)isMyFeedHome {

  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.info = info;
    _isMyFeedHome = isMyFeedHome;

  }
  return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

  [super setSelected:selected animated:animated];
}

- (void)imageTap {

}

- (void)initContentView {

  _viewHeight = PublicDetailCellDefaultSpace;

  if (_info.isFirstPic) {
    if (!_beginImageView) {
      _beginImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _viewHeight + 3, 15, 14)];
      _beginImageView.image = UIIMAGE_FROMPNG(@"qqnr_pd_bike");
    }
    [self addSubview:_beginImageView];

    if (!_dateLabel) {
      _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, _viewHeight, 230, 20)];
      _dateLabel.backgroundColor = [UIColor clearColor];
      _dateLabel.lineBreakMode = UILineBreakModeWordWrap;
      _dateLabel.numberOfLines = 0;
      _dateLabel.textColor = [UIColor whiteColor];
      _dateLabel.textAlignment = UITextAlignmentLeft;
      _dateLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    _dateLabel.text = _info.takePicDateStr;
    [self addSubview:_dateLabel];
    _viewHeight += _dateLabel.frame.size.height;
    _viewHeight += 5;
  } else {
    [_beginImageView removeFromSuperview];
    [_dateLabel removeFromSuperview];
  }

  [self inputStackView];

  _viewHeight += PublicDetailCellDefaultDownSpace;
}


//添加图片
- (void)inputStackView {

  CGFloat width = PublicDetailCellWidth;
  CGFloat height;
  if (self.info.width == 0 || self.info.height == 0) {
    height = PublicDetailCellWidth;
  } else if (self.info.width / self.info.height > 1) {
    height = self.info.height * 1.0 / self.info.width * width;
  } else {
    height = self.info.height * 1.0 / self.info.width * width;
  }
  _viewHeight += 10;

  if (!_imageView) {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PublicDetailCellOriginX, _viewHeight, width, height)];
    _imageView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
    _imageView.userInteractionEnabled = YES;
    _imageView.layer.borderColor=[[UIColor getColor:@"747474"]CGColor];
    _imageView.layer.borderWidth=1.0;
    [_imageView addGestureRecognizer:tap];
    if(_isMyFeedHome){
      UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showDeleteAction:)];
      [_imageView addGestureRecognizer:longPress];
    }
  } else {
    _imageView.frame = CGRectMake(PublicDetailCellOriginX, _viewHeight, width, height);
  }
  NSURL *url = [QiNiuUtils getUrlBySizeToUrl:_imageView.frame.size url:_info.photoUrl type:QINIUMODE_DEDEFAULT];
  [_imageView setImageWithURL:url placeholderImage:nil];

  if (!_imageBGView) {
    _imageBGView = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView.frame.origin.x - 8, _imageView.frame.origin.y - 5, _imageView.frame.size.width + 16, _imageView.frame.size.height + 19)];

  } else {
    _imageBGView.frame = CGRectMake(_imageView.frame.origin.x - 8, _imageView.frame.origin.y - 5, _imageView.frame.size.width + 16, _imageView.frame.size.height + 19);
  }
  _imageBGView.image = [UIIMAGE_FROMPNG(@"qqnr_pd_picbg") stretchableImageWithLeftCapWidth:50 topCapHeight:50];

  [self addSubview:_imageBGView];
  [self addSubview:_imageView];

  _viewHeight += _imageBGView.frame.size.height;


  CGFloat likeViewWidth = 40;
  NSString *desc = self.info.pictureDescription;
  CGSize linesSz = [desc sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(PublicDetailCellWidth - likeViewWidth-40, 70) lineBreakMode:(NSLineBreakMode) UILineBreakModeCharacterWrap];

  CGFloat bgHeight = linesSz.height + 30;
  bgHeight = bgHeight < 30 ? 30 : bgHeight;

  CGRect rect = CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y + _imageView.frame.size.height - bgHeight, _imageView.frame.size.width, bgHeight);

  if (!_imageViewDescView) {
    _imageViewDescView = [[UIView alloc] initWithFrame:rect];
    _imageViewDescView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageViewDescView];
  } else {
    _imageViewDescView.frame = rect;
  }
  [self bringSubviewToFront:_imageViewDescView];

  if (!_imageViewDescBG) {
    _imageViewDescBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageViewDescView.frame.size.width, _imageViewDescView.frame.size.height)];
    [_imageViewDescView addSubview:_imageViewDescBG];
  } else {
    _imageViewDescBG.frame = CGRectMake(0, 0, _imageViewDescView.frame.size.width, _imageViewDescView.frame.size.height);
  }
  _imageViewDescBG.image = [UIIMAGE_FROMPNG(@"qqnr_pd_descbg") stretchableImageWithLeftCapWidth:10 topCapHeight:10];


  if(!_avatorImageView){
    _avatorImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 25)];
    [_imageViewDescView addSubview:_avatorImageView];
  }else{
    _avatorImageView.frame=CGRectMake(10, 5, 25, 25);
  }
  url=[QiNiuUtils getUrlBySizeToUrl:_avatorImageView.frame.size url:self.info.user.savatorUrl type:QINIUMODE_DESHORT];
  [_avatorImageView setImageWithURL:url placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];
  
  if (!_descLabel) {
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, PublicDetailCellWidth - likeViewWidth - 30 , linesSz.height)];
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.lineBreakMode = UILineBreakModeWordWrap;
    _descLabel.numberOfLines = 0;
    _descLabel.textColor = [UIColor whiteColor];
    _descLabel.textAlignment = UITextAlignmentLeft;
    _descLabel.font = [UIFont boldSystemFontOfSize:12];
    [_imageViewDescView addSubview:_descLabel];
  } else {
    _descLabel.frame = CGRectMake(40, 5, PublicDetailCellWidth - likeViewWidth, linesSz.height);
  }
  _descLabel.text = desc;

  if (!_isMyFeedHome) {
    if (!_likeBtn) {
      _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [_imageViewDescView addSubview:_likeBtn];
    }
    _likeBtn.frame = CGRectMake(_imageViewDescView.frame.size.width - likeViewWidth, _imageViewDescView.frame.size.height - 20, 17, 15);


    if (!_likeCountLabel) {
      _likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageViewDescView.frame.size.width - 20, _imageViewDescView.frame.size.height - 22, 10, 15)];
      _likeCountLabel.backgroundColor = [UIColor clearColor];
      _likeCountLabel.textAlignment = UITextAlignmentCenter;
      _likeCountLabel.textColor = [UIColor whiteColor];

      [_imageViewDescView addSubview:_likeCountLabel];
    } else {
      _likeCountLabel.frame = CGRectMake(_imageViewDescView.frame.size.width - 20, _imageViewDescView.frame.size.height - 22, 10, 15);
    }
    _likeCountLabel.text = INT2STR(self.info.likeCount);

    if (!_likeClickView) {
      _likeClickView = [[UIView alloc] initWithFrame:CGRectMake(_imageViewDescView.frame.size.width - likeViewWidth, 0, likeViewWidth, _imageViewDescView.frame.size.height)];
      _likeClickView.userInteractionEnabled = YES;
      _likeClickView.backgroundColor = [UIColor clearColor];
      UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeBtnClick:)];
      [_likeClickView addGestureRecognizer:gesture];
      [_imageViewDescView addSubview:_likeClickView];
    } else {
      _likeClickView.frame = CGRectMake(_imageViewDescView.frame.size.width - likeViewWidth, 0, likeViewWidth, _imageViewDescView.frame.size.height);
    }

  }
  if (self.info.liked) {
    [_likeBtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_likedpic") forState:UIControlStateNormal];
    [_likeBtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_likedpic") forState:UIControlStateHighlighted];
    _likeClickView.userInteractionEnabled = NO;
  } else {
    [_likeBtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_likepic") forState:UIControlStateNormal];
    [_likeBtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_likepic") forState:UIControlStateHighlighted];
    _likeClickView.userInteractionEnabled = YES;
  }
}

- (void)likeBtnClick:(id)sender {

  BOOL succ = false;
  if (self.delegate) {
    succ = [self.delegate likeBtnClick:self picture:self.info];
  }
  if (succ) {
    self.info.liked = TRUE;
    _likeClickView.userInteractionEnabled = NO;
    [_likeBtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_likedpic") forState:UIControlStateNormal];
    [_likeBtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_likedpic") forState:UIControlStateHighlighted];
    self.info.likeCount += 1;
    _likeCountLabel.text = INT2STR(self.info.likeCount);
  }

}

- (void)showDeleteAction:(UIGestureRecognizer *)gestureRecognizer  {

  if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
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

@end
