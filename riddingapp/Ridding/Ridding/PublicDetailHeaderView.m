//
//  PublicDetailHeaderView.m
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import "PublicDetailHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "DetailTextView.h"
#import "UIColor+XMin.h"
#define iconSize @"26"
#define frameSize @"28"
@implementation PublicDetailHeaderView

- (id)initWithFrame:(CGRect)frame info:(ActivityInfo*)info
{
    self = [super initWithFrame:frame];
    if (self) {
      _info=info;
      self.backgroundColor=[UIColor clearColor];
      UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
      [frameView setBackgroundColor:[UIColor whiteColor]];
      frameView.layer.cornerRadius = [frameSize doubleValue]/1.5;
      frameView.clipsToBounds = YES;
      [self addSubview:frameView];
      
      UIImageView *__imageView=[[UIImageView alloc]initWithFrame:CGRectInset(frameView.frame, ([frameSize doubleValue]-[iconSize doubleValue])/2.0, ([frameSize doubleValue]-[iconSize doubleValue])/2.0)];
      __imageView.layer.cornerRadius = [iconSize doubleValue]/1.5;
      __imageView.clipsToBounds = YES;
      NSURL *url = [NSURL URLWithString:info.leaderSAvatorUrl];
      [__imageView setImageWithURL:url placeholderImage:UIIMAGE_FROMPNG(@"duser")];
      [self addSubview:__imageView];
      
      DetailTextView *detailTextView = [[DetailTextView alloc]initWithFrame:CGRectMake(70, 10, 250, 30)];
      detailTextView.backgroundColor=[UIColor clearColor];
      [detailTextView setText:_info.name WithFont:[UIFont boldSystemFontOfSize:20] AndColor:[UIColor getColor:ColorBlue]];
      detailTextView.textAlignment=NSTextAlignmentCenter;
      [self addSubview:detailTextView];
      
      DetailTextView *detailTextView1 = [[DetailTextView alloc]initWithFrame:CGRectMake(180, 40, 80, 15)];
      detailTextView1.backgroundColor=[UIColor clearColor];
      [detailTextView1 setText:[NSString stringWithFormat:@"%0.2fKM",_info.distance] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorOrange]];
      detailTextView1.textAlignment=NSTextAlignmentCenter;
      [self addSubview:detailTextView1];
      
      DetailTextView *detailTextView2 = [[DetailTextView alloc]initWithFrame:CGRectMake(70, 40, 100, 15)];
      detailTextView2.backgroundColor=[UIColor clearColor];
      [detailTextView2 setText:_info.createTime WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorOrange]];
      detailTextView2.textAlignment=NSTextAlignmentLeft;
      [self addSubview:detailTextView2];
      

    }
    return self;
}

- (void)drawRect:(CGRect)rect{
  
//  
//  [_info.createTime drawInRect:CGRectMake(70, 40, 100, 10) withFont:[UIFont fontWithName:@"Arial" size:10] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentLeft];
//  [[NSString stringWithFormat:@"%0.2fKM",_info.distance] drawInRect:CGRectMake(180, 40, 80, 10) withFont:[UIFont fontWithName:@"Arial" size:10] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentCenter];

  
}


@end
