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
  UILabel *_timeLabel;
  UIImageView *_avatorImageView;
  UILabel *_dateLabel;
  UIImageView *_imageView;
  UIImageView *_beginImageView;
  UIImageView *_imageViewDescBG;
  UILabel *_descLabel;
  UIView *_imageViewDescView;
}
@end

@implementation PublicDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier info:(RiddingPicture *)info {

  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.info = info;


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
      _beginImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _viewHeight + 3, 17, 17)];
      _beginImageView.image = UIIMAGE_FROMPNG(@"PublicView_FirstImg");
    }
    [self addSubview:_beginImageView];

    if (!_dateLabel) {
      _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, _viewHeight, 230, 20)];
      _dateLabel.backgroundColor = [UIColor clearColor];
      _dateLabel.lineBreakMode = UILineBreakModeWordWrap;
      _dateLabel.numberOfLines = 0;
      _dateLabel.textColor = [UIColor getColor:barTextColor];
      _dateLabel.textAlignment = UITextAlignmentLeft;
      _dateLabel.font = [UIFont boldSystemFontOfSize:12];
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

  if (!_imageView) {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(PublicDetailCellOriginX+ 20, _viewHeight, width, height)];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _imageView.layer.borderWidth = 2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:tap];
    [self addSubview:_imageView];
  } else {
    _imageView.frame = CGRectMake(PublicDetailCellOriginX+ 20, _viewHeight, width, height);
    _imageView.image = nil;
  }
  NSURL *url = [QiNiuUtils getUrlBySizeToUrl:_imageView.frame.size url:_info.photoUrl type:QINIUMODE_DESHORT];
  [_imageView setImageWithURL:url placeholderImage:nil];

  CGFloat descViewWidth = 151;
  NSString *desc = self.info.pictureDescription;
  CGSize linesSz = [desc sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(descViewWidth - 10, 70) lineBreakMode:(NSLineBreakMode) UILineBreakModeCharacterWrap];
  CGFloat bgHeight = linesSz.height + 10 + 20;


  if (!_imageViewDescView) {
    _imageViewDescView = [[UIView alloc] initWithFrame:CGRectMake(_imageView.frame.size.width + _imageView.frame.origin.x - descViewWidth - 2, _viewHeight + height / 2 - bgHeight / 2, descViewWidth, bgHeight)];
    _imageViewDescView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageViewDescView];
  } else {
    _imageViewDescView.frame = CGRectMake(_imageView.frame.size.width + _imageView.frame.origin.x - descViewWidth - 2, _viewHeight + height / 2 - bgHeight / 2, descViewWidth, bgHeight);
  }

  if (!_imageViewDescBG) {
    _imageViewDescBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageViewDescView.frame.size.width, _imageViewDescView.frame.size.height)];
    _imageViewDescBG.image = UIIMAGE_FROMPNG(@"PublicDetail_ImageBG");
    [_imageViewDescView addSubview:_imageViewDescBG];
  } else {
    _imageViewDescBG.frame = CGRectMake(0, 0, _imageViewDescView.frame.size.width, _imageViewDescView.frame.size.height);
  }

  if (!_descLabel) {
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, linesSz.width, linesSz.height)];
    _descLabel.backgroundColor = [UIColor clearColor];
    _descLabel.lineBreakMode = UILineBreakModeWordWrap;
    _descLabel.numberOfLines = 0;
    _descLabel.textColor = [UIColor whiteColor];
    _descLabel.textAlignment = UITextAlignmentLeft;
    _descLabel.font = [UIFont boldSystemFontOfSize:12];
    [_imageViewDescView addSubview:_descLabel];
  } else {
    _descLabel.frame = CGRectMake(10, 5, linesSz.width, linesSz.height);
  }
  _descLabel.text = desc;

  _viewHeight += height;
}

- (void)imageViewTap:(UIGestureRecognizer *)gesture {

  UIImageView *imageView = (UIImageView *) gesture.view;
  if (self.delegate) {
    [self.delegate imageViewClick:self picture:self.info imageView:imageView];
  }
}

@end
