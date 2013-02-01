//
//  MBImageFilterScrollView.m
//  MMBang
//
//  Created by zys on 12-10-15.
//  Copyright (c) 2012年 儒果网络. All rights reserved.
//

#import "MPImageFilterScrollView.h"
#import "MPImageFilter.h"

#define diffWidth 2
#define itemWidth 60.0f

@implementation MPImageFilterScrollView
@synthesize mpDelegate;
@synthesize filters;

- (id)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}

- (void)loadFilters :(Source_Type)type {

  self.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"pz_lj_dt")];
  int index = 0;
  for (int i = 0; i < filterTotalCount; i++) {
    if ([self needTrim:type index:i]) {
      continue;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + index * (itemWidth+ 10) - diffWidth, diffWidth, 65.0f, 65.0f)];
    imageView.image = UIIMAGE_FROMPNG(@"pz_kuang");
    imageView.hidden = YES;
    [self addSubview:imageView];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:[MPImageFilter getFileName:index]] forState:UIControlStateNormal];
    button.frame = CGRectMake(10 + index * (itemWidth+ 10), 5.0f, itemWidth, itemWidth);
    button.layer.cornerRadius = 7.0f;
    button.layer.masksToBounds = YES;
    UIBezierPath *bi = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                             byRoundingCorners:UIRectCornerAllCorners
                                                   cornerRadii:CGSizeMake(7.0, 7.0)];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = button.bounds;
    maskLayer.path = bi.CGPath;
    button.layer.mask = maskLayer;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor blackColor] CGColor];

    [button addTarget:self
               action:@selector(filterClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    button.tag = index;
    if (index == 0) {
      [button setSelected:YES];
    }
    [self addSubview:button];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 + index * (itemWidth+ 10), 5.0f + itemWidth, itemWidth, 20.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [MPImageFilter getFilterName:index];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    index++;
  }
  [self setContentSize:CGSizeMake(10 + index * (itemWidth+ 10), 75.0)];
}

- (BOOL)needTrim:(Source_Type)type index:(int)index {

  if (type == LIVE_CAMERA) {
    if (index == 3) {
      return TRUE;
    }
  }
  return FALSE;
}


- (void)filterClicked:(UIButton *)sender {

  for (UIView *view in self.subviews) {
    if ([view isKindOfClass:[UIButton class]]) {
      [(UIButton *) view setSelected:NO];
    }
    if ([view isKindOfClass:[UIImageView class]] && view.frame.origin.x + diffWidth != sender.frame.origin.x) {
      if (![view isHidden]) {
        [view setHidden:YES];
      }
    }
    if ([view isKindOfClass:[UIImageView class]] && view.frame.origin.x + diffWidth == sender.frame.origin.x) {
      if ([view isHidden]) {
        [view setHidden:NO];
      }
    }
  }

  [sender setSelected:YES];
  if (self.filters) {
    if (self.mpDelegate) {
      [self.mpDelegate mpImageFilter:self removeAllTarget:sender.tag];
    }
    [self removeAllTargets];
    [self.filters release];
  }
  self.filters = [MPImageFilter initFilter:sender.tag];
  if (self.mpDelegate) {
    [self.mpDelegate mpImageFilter:self filterClick:sender.tag];
  }
}

- (void)addAllFilterByFilter:(GPUImageOutput *)output {

  for (int i = 0; i < [self.filters count]; i++) {
    if (i == 0) {
      [output addTarget:[self.filters objectAtIndex:i]];
    } else {
      [[self.filters objectAtIndex:i - 1] addTarget:[self.filters objectAtIndex:i]];
    }
    [[self.filters objectAtIndex:i] release];
  }
}

- (void)removeAllTargets {

  if (self.filters) {
    for (GPUImageFilter *filter in self.filters) {
      [filter removeAllTargets];
    }
  }
}


- (void)dealloc {

  mpDelegate = nil;
  [filters release];
  [super dealloc];
}

@end
