//
//  QQNRFeedTableCell.m
//  Ridding
//
//  Created by zys on 12-9-27.
//
//
#import <QuartzCore/QuartzCore.h>
#import "QQNRFeedTableCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UIColor+XMin.h"
#import "DetailTextView.h"
#import "UIImage+Utilities.h"
#import "QiNiuUtils.h"


@implementation QQNRFeedTableCell
@synthesize delegate=_delegate;
@synthesize ridding=_ridding;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ridding:(Ridding*)ridding
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.ridding=ridding;
  }
  return self;
}


- (void)initContentView{
  
  self.avatorBtn.layer.cornerRadius=5;
  self.avatorBtn.layer.masksToBounds=YES;
  self.avatorBtn.showsTouchWhenHighlighted=YES;
  [self.avatorBtn setImage:UIIMAGE_FROMPNG(@"duser") forState:UIControlStateNormal];
  NSString *url=[QiNiuUtils getUrlBySize:self.avatorBtn.frame.size url:_ridding.leaderUser.savatorUrl type:QINIUMODE_DESHORT];
  UIImage *image=[[SDImageCache sharedImageCache]imageFromKey:url];
  if(!image){
    image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    [[SDImageCache sharedImageCache] storeImage:image forKey:url];
  }
  [self.avatorBtn setImage:image forState:UIControlStateNormal];
  
  
  [self.nameLabel setText:[NSString stringWithFormat:@"活动: %@",_ridding.riddingName] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor blackColor]];
  
  
  NSString *distance=[NSString stringWithFormat:@"%0.2fKM",_ridding.map.distance*1.0/1000];
  [self.distanceLabel setText:[NSString stringWithFormat:@"行程: %@",distance] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor blackColor]];
  
  NSString *userCountStr=[NSString stringWithFormat:@"骑友 : 共%d人 ",_ridding.userCount];
  [self.teamCountLabel setText:userCountStr WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor blackColor]];
  
  NSString *beginLocationStr=[NSString stringWithFormat:@"起点 : %@",_ridding.map.beginLocation];
  [self.beginLocationLabel setText:beginLocationStr WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor blackColor]];
  
  NSString *endLocationStr=[NSString stringWithFormat:@"终点 : %@",_ridding.map.endLocation];
  [self.endLocationLabel setText:endLocationStr WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor blackColor]];
  
  
  
  if(![_ridding isEnd]){
    [self.nameLabel setKeyWordTextString:_ridding.riddingName WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorOrange]];
    [self.distanceLabel setKeyWordTextString:distance WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorOrange]];
    [self.teamCountLabel setKeyWordTextString:[NSString stringWithFormat:@"%d",_ridding.userCount] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorOrange]];

    [self.beginLocationLabel setKeyWordTextString:[NSString stringWithFormat:@"%@",_ridding.map.beginLocation] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorOrange]];

    [self.endLocationLabel setKeyWordTextString:[NSString stringWithFormat:@"%@",_ridding.map.endLocation] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorOrange]];

  }else{
    [self.nameLabel setKeyWordTextString:_ridding.riddingName WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorBlue]];
    [self.distanceLabel setKeyWordTextString:distance WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorBlue]];
    [self.teamCountLabel setKeyWordTextString:[NSString stringWithFormat:@"%d",_ridding.userCount] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorBlue]];
    [self.beginLocationLabel setKeyWordTextString:[NSString stringWithFormat:@"%@",_ridding.map.beginLocation] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorBlue]];
    [self.endLocationLabel setKeyWordTextString:[NSString stringWithFormat:@"%@",_ridding.map.endLocation] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorBlue]];

  }
  
  self.stackView.contentMode=UIViewContentModeRedraw;
  self.stackView.displayAsStack = YES;
  self.stackView.backgroundColor=[UIColor clearColor];
  NSString *urlString=[QiNiuUtils getUrlBySize:self.stackView.frame.size url:_ridding.map.avatorPicUrl type:QINIUMODE_DEDEFAULT];
  image=[[SDImageCache sharedImageCache]imageFromKey:urlString];
  if(!image){
    image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    [[SDImageCache sharedImageCache] storeImage:image forKey:urlString];
  }
  [self.stackView setImage:image];
  
  
  UITapGestureRecognizer *labelTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(statusTap:)];
  [self.statusLabel addGestureRecognizer:labelTap];
  self.statusLabel.userInteractionEnabled=YES;
  self.statusLabel.layer.cornerRadius=5;
  self.statusLabel.layer.masksToBounds=YES;
  self.statusLabel.textAlignment=UITextAlignmentCenter;
  self.statusLabel.font=[UIFont fontWithName:@"Arial" size:11];
  self.statusLabel.textColor=[UIColor whiteColor];
  if (![_ridding isEnd]) {
    self.statusLabel.text=@"进行中";
    self.statusLabel.backgroundColor=[UIColor getColor:ColorOrange];
  }else{
    self.statusLabel.text=@"已结束";
    self.statusLabel.backgroundColor=[UIColor getColor:ColorBlue];
  }
  
 // [self setNeedsDisplay];
}

- (IBAction)leaderViewTap:(id)selector
{
  if ([self.delegate respondsToSelector:@selector(leaderTap:)]) {
    [self.delegate performSelector:@selector(leaderTap:) withObject:_ridding];
  }
}


- (void)statusTap:(id)selector{
  if(self.delegate){
    [self.delegate statusTap:self];
  }
}

- (void)drawRect:(CGRect)rect
{
//  UIImage *divLineImage = [UIImage imageNamed:@"分割线.png"];
//  [divLineImage drawInRect:CGRectMake(self.frame.origin.x, self.frame.size.height-2 , self.frame.size.width, 2)];
}

@end
