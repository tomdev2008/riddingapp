//
//  CreateAnnotationView.m
//  Ridding
//
//  Created by zys on 12-11-15.
//
//

#import "CreateAnnotationView.h"

@implementation CreateAnnotationView

- (id)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

  [super setSelected:selected animated:animated];
  if (selected) {
    [self.calloutView setFrame:CGRectMake(-24, 35, 0, 0)];
    [self.calloutView sizeToFit];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:UIIMAGE_FROMPNG(@"qqnr_dl_button_delete")];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
    [imageView addGestureRecognizer:tapGesture];
    self.rightCalloutAccessoryView = imageView;

    [self animateCalloutAppearance];
    [self addSubview:self.calloutView];
  }
  else {
    //Remove your custom view...
    [self.calloutView removeFromSuperview];
  }
}


- (void)imageViewTap:(UITapGestureRecognizer *)gesture {

  if (self.delegate) {
    [self.delegate imageViewDelete:self];
  }
}


- (void)animateCalloutAppearance {

  CGFloat scale = 0.001f;
  self.calloutView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -50);

  [UIView animateWithDuration:0.15 delay:0 options:(UIViewAnimationOptions) UIViewAnimationCurveEaseOut animations:^{
    CGFloat scale = 1.1f;
    self.calloutView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 2);
  }                completion:^(BOOL finished) {
    [UIView animateWithDuration:0.1 delay:0 options:(UIViewAnimationOptions)UIViewAnimationCurveEaseInOut animations:^{
      CGFloat scale = 0.95;
      self.calloutView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -2);
    }                completion:^(BOOL finished) {
      [UIView animateWithDuration:0.075 delay:0 options:(UIViewAnimationOptions)UIViewAnimationCurveEaseInOut animations:^{
        CGFloat scale = 1.0;
        self.calloutView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 0);
      }                completion:nil];
    }];
  }];
}

@end
