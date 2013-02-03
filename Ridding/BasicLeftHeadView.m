//
//  BasicLeftHeadView.m
//  Ridding
//
//  Created by zys on 13-1-22.
//
//

#import "BasicLeftHeadView.h"

@implementation BasicLeftHeadView

- (id)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];
  if (self) {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 19, 183, 22)];
    imageView.image = UIIMAGE_FROMPNG(@"qqnr_ln_title");
    [self addSubview:imageView];

    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, self.frame.size.width, 2)];
    lineView.image = [UIIMAGE_FROMPNG(@"qqnr_ln_sepator") stretchableImageWithLeftCapWidth:2 topCapHeight:0];
    [self addSubview:lineView];
  }
  return self;
}

@end
