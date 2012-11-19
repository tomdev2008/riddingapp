//
//  QQNRFeedHeaderView.m
//  Ridding
//
//  Created by zys on 12-9-27.
//
//

#import "QQNRFeedHeaderView.h"
#import "StaticInfo.h"
#import "UIImageView+WebCache.h"
#import "UIColor+XMin.h"
#import "RequestUtil.h"
#import <QuartzCore/QuartzCore.h>
#define iconSize @"24"
#define frameSize @"28"
@implementation QQNRFeedHeaderView
@synthesize delegate=_delegate;
- (id)initWithFrame:(CGRect)frame user:(User*)user
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMFILE(@"feed_Bg",@"png")];
      
      UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(40, self.frame.size.height-60, 40, 40)];
      [frameView setBackgroundColor:[UIColor clearColor]];
      frameView.layer.cornerRadius = [frameSize doubleValue]/1.5;
      frameView.clipsToBounds = YES;
      [self addSubview:frameView];
      
      UIImageView *__imageView=[[UIImageView alloc]initWithFrame:CGRectInset(frameView.frame, ([frameSize doubleValue]-[iconSize doubleValue])/2.0, ([frameSize doubleValue]-[iconSize doubleValue])/2.0)];
      __imageView.layer.cornerRadius = [iconSize doubleValue]/1.5;
      __imageView.clipsToBounds = YES;
      NSURL *url = [NSURL URLWithString:user.savatorUrl];
      [__imageView setImageWithURL:url placeholderImage:UIIMAGE_FROMPNG(@"duser")];
      [self addSubview:__imageView];
      
      
      UILabel *__userName = [[UILabel alloc] initWithFrame:CGRectMake(90, self.frame.size.height-60, 100, 20)];
      __userName.textAlignment = UITextAlignmentLeft;
      __userName.textColor = [UIColor whiteColor];
      __userName.backgroundColor = [UIColor clearColor];
      __userName.shadowColor = [UIColor blackColor];
      __userName.shadowOffset = CGSizeMake(1.0, 0.0);
      __userName.font = [UIFont boldSystemFontOfSize:18];
      __userName.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
      __userName.text = user.name;
      [self addSubview:__userName];
      
      _mileStone  = [[UILabel alloc] initWithFrame:CGRectMake(90, self.frame.size.height-50, 100, 40)];
      _mileStone.textAlignment = UITextAlignmentLeft;
      _mileStone.textColor = [UIColor whiteColor];
      _mileStone.backgroundColor = [UIColor clearColor];
      _mileStone.shadowColor = [UIColor blackColor];
      _mileStone.shadowOffset = CGSizeMake(1.0, 0.0);
      _mileStone.font = [UIFont fontWithName:@"Arial" size:12];
      _mileStone.text =[NSString stringWithFormat:@"总距离: %@",[user getTotalDistanceToKm]];
      [self addSubview:_mileStone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishRidding:) name:kFinishNotification object:nil];
           
    }
    return self;
}
- (void)finishRidding:(NSNotification*)noti{
  NSDictionary *category=[noti userInfo];
  _mileStone.text=[category objectForKey:@"distance"];
}

- (void)drawRect:(CGRect)rect{
  UIImage *avatorBg = UIIMAGE_FROMPNG(@"feed_xiantou");
  [avatorBg drawAtPoint:CGPointMake(58, self.frame.size.height-38)];
  
  UIImage *divLineImage = [UIImage imageNamed:@"分割线.png"];
  [divLineImage drawInRect:CGRectMake(self.frame.origin.x, self.frame.size.height-1 , self.frame.size.width, 1)];
  
}

@end
