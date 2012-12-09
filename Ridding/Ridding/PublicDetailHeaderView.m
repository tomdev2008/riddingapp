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
#import "QiNiuUtils.h"
#import "NSDate+Addition.h"
#import "PublicDetailCell.h"
#define iconSize @"26"
#define frameSize @"28"
@implementation PublicDetailHeaderView

- (id)initWithFrame:(CGRect)frame ridding:(Ridding*)ridding
{
    self = [super initWithFrame:frame];
    if (self) {
      _ridding=ridding;
      self.backgroundColor=[UIColor clearColor];
      UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
      [frameView setBackgroundColor:[UIColor whiteColor]];
      frameView.layer.cornerRadius = [frameSize doubleValue]/1.5;
      frameView.clipsToBounds = YES;
      [self addSubview:frameView];
      
      UIImageView *__imageView=[[UIImageView alloc]initWithFrame:CGRectInset(frameView.frame, ([frameSize doubleValue]-[iconSize doubleValue])/2.0, ([frameSize doubleValue]-[iconSize doubleValue])/2.0)];
      __imageView.layer.cornerRadius = 10;
      __imageView.clipsToBounds = YES;
      NSURL *url = [NSURL URLWithString:_ridding.leaderUser.savatorUrl];
      [__imageView setImageWithURL:url placeholderImage:UIIMAGE_FROMPNG(@"duser")];
      [self addSubview:__imageView];
      
      DetailTextView *detailTextView = [[DetailTextView alloc]initWithFrame:CGRectMake(70, 10, 250, 30)];
      detailTextView.backgroundColor=[UIColor clearColor];
      [detailTextView setText:_ridding.riddingName WithFont:[UIFont boldSystemFontOfSize:20] AndColor:[UIColor getColor:ColorBlue]];
      detailTextView.textAlignment=NSTextAlignmentCenter;
      [self addSubview:detailTextView];
      
      DetailTextView *detailTextView1 = [[DetailTextView alloc]initWithFrame:CGRectMake(70, 40, 100, 15)];
      detailTextView1.backgroundColor=[UIColor clearColor];
      [detailTextView1 setText:[NSString stringWithFormat:@"总行程 : %0.2fKM",_ridding.map.distance*1.0/1000] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorOrange]];
      detailTextView1.textAlignment=NSTextAlignmentCenter;
      [self addSubview:detailTextView1];
      
      DetailTextView *detailTextView2 = [[DetailTextView alloc]initWithFrame:CGRectMake(180, 40, 140, 15)];
      detailTextView2.backgroundColor=[UIColor clearColor];
      [detailTextView2 setText:[NSString stringWithFormat:@"创建时间: %@",_ridding.createTimeStr] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:COLOR_GRAY];
      detailTextView2.textAlignment=NSTextAlignmentLeft;
      [self addSubview:detailTextView2];
      
      UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(PublicDetailCellOriginX, 70, PublicDetailCellWidth, 180)];
      url=[QiNiuUtils getUrlBySizeToUrl:imageView.frame.size url:_ridding.map.avatorPicUrl type:QINIUMODE_DEDEFAULT];
      [imageView setImageWithURL:url placeholderImage:nil];
      imageView.layer.borderColor=[[UIColor whiteColor]CGColor];
      [self addSubview:imageView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
}


@end
