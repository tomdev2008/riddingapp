//
//  LocationView.m
//  Ridding
//
//  Created by zys on 12-11-16.
//
//

#import "LocationView.h"

@implementation LocationView

- (id)initWithFrame:(CGRect)frame{

  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}


- (void)setSubViews {

  switch (self.annotation.type) {
    case MyAnnotationType_BEGIN: {
      UIImage *image = UIIMAGE_FROMPNG(@"qqnr_dl_tabbar_icon_start");
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 8, 26, 34)];
      imageView.image = image;
      [self addSubview:imageView];
    }
      break;
    case MyAnnotationType_MID: {
      UIImage *image = UIIMAGE_FROMPNG(@"qqnr_dl_tabbar_icon_pass");
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 8, 26, 34)];
      imageView.image = image;
      [self addSubview:imageView];
    }
      break;
    case MyAnnotationType_END: {
      UIImage *image = UIIMAGE_FROMPNG(@"qqnr_dl_tabbar_icon_end");
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 8, 26, 34)];
      imageView.image = image;
      [self addSubview:imageView];
    }
      break;
    default:
      DLog(@"error!");
      break;
  }
}

@end
