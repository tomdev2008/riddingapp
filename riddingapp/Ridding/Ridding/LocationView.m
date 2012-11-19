//
//  LocationView.m
//  Ridding
//
//  Created by zys on 12-11-16.
//
//

#import "LocationView.h"

@implementation LocationView

- (id)initWithFrame:(CGRect)frame type:(LOCATIONTYPE)type
{
  self = [super initWithFrame:frame];
  if (self) {
    self.type=type;
  }
  return self;
}



- (void)setSubViews{
  switch (_type) {
    case LOCATIONTYPE_BEGIN:
    {
      UIImage *image=UIIMAGE_FROMPNG(@"起点图标");
//      CGFloat width= CGImageGetWidth([image CGImage]);
//      CGFloat height= CGImageGetHeight([image CGImage]);
      UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 30)];
      imageView.image=image;
      [self addSubview:imageView];
    }
      break;
    case LOCATIONTYPE_MID:
    {
      UIImage *image=UIIMAGE_FROMPNG(@"greenbiker");
      UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
      imageView.image=image;
      [self addSubview:imageView];
    }
      break;
    case LOCATIONTYPE_END:
    {
      UIImage *image=UIIMAGE_FROMPNG(@"endPoint");
      UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 30)];
      imageView.image=image;
      [self addSubview:imageView];
    }
      break;
    default:
      DLog(@"error!");
      break;
  }
}

@end
