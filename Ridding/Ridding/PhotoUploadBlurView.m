//
//  PhotoUploadBlurView.m
//  Ridding
//
//  Created by zys on 12-10-27.
//
//

#import "PhotoUploadBlurView.h"
#import "YLProgressBar.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+XMin.h"
@implementation PhotoUploadBlurView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.layer.cornerRadius = 10.f;
      self.layer.borderColor = [UIColor getColor:ColorOrange].CGColor;
      self.layer.borderWidth = 1.f;
      _imageView=[[SWSnapshotStackView alloc]initWithFrame:CGRectMake(20, 20, 220, 180)];
      _imageView.displayAsStack=NO;
      _imageView.contentMode=UIViewContentModeRedraw;
      _imageView.backgroundColor=[UIColor clearColor];
      _progressBar=[[YLProgressBar alloc]initWithFrame:CGRectMake(40, 230, 180, 10)];
      _label=[[UILabel alloc]initWithFrame:CGRectMake(0, 205, self.frame.size.width, 20)];
      _label.backgroundColor=[UIColor clearColor];
      _label.textColor=[UIColor getColor:ColorOrange];
      _label.textAlignment=UITextAlignmentCenter;
      _label.font=[UIFont fontWithName:@"Arial" size:13];
      [self addSubview:_label];
      [self addSubview:_imageView];
      [self addSubview:_progressBar];
      self.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    }
    return self;
}

- (void)setValue:(UIImage*)image text:(NSString*)text value:(float)value{
  _imageView.image=image;
  _label.text=text;
  _progressBar.progress=value;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
