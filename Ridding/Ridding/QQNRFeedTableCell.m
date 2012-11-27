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
@interface CompositeSubviewBasedApplicationCellContentView : UIView
{
  QQNRFeedTableCell *_cell;
  CGFloat _height;
}
- (CGFloat)getCellHeight;
@end

@implementation CompositeSubviewBasedApplicationCellContentView

- (id)initWithFrame:(CGRect)frame cell:(QQNRFeedTableCell *)cell
{
  if (self = [super initWithFrame:frame])
  {
    _cell = cell;
    _height=0;
    self.opaque = YES;
    self.backgroundColor = _cell.backgroundColor;
    [self initCell];
    [self inputStackView];
  }
  
  return self;
}

- (void)drawRect:(CGRect)rect
{
  NSString *begin=@"起点:";
  [begin drawInRect:CGRectMake(65, 315, 35, 20) withFont:[UIFont fontWithName:@"Arial" size:12] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentCenter];
  [_cell.info.beginLocation drawInRect:CGRectMake(105, 315, 200, 20) withFont:[UIFont fontWithName:@"Arial" size:12] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentLeft];
  NSString *end=@"终点:";
  [end drawInRect:CGRectMake(65, 330, 35, 20) withFont:[UIFont fontWithName:@"Arial" size:12] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentCenter];
  [_cell.info.endLocation drawInRect:CGRectMake(105, 330, 200, 20) withFont:[UIFont fontWithName:@"Arial" size:12] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentLeft];
  [_cell.info.leaderName drawInRect:CGRectMake(5, 60, 50, 20) withFont:[UIFont fontWithName:@"Arial" size:12] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentCenter];
  UIImage *divLineImage = [UIImage imageNamed:@"分割线.png"];
  [divLineImage drawInRect:CGRectMake(self.frame.origin.x, self.frame.size.height-2 , self.frame.size.width, 2)];
}

- (void)initCell{
  if(_cell.info){
    UIButton *avatorBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    avatorBtn.frame=CGRectMake(10, 20, 38, 38);
    [avatorBtn addTarget:self action:@selector(leaderViewTap:) forControlEvents:UIControlEventTouchUpInside];
    avatorBtn.layer.cornerRadius=5;
    avatorBtn.layer.masksToBounds=YES;
    avatorBtn.showsTouchWhenHighlighted=YES;
    [avatorBtn setImage:UIIMAGE_FROMPNG(@"duser") forState:UIControlStateNormal];
    UIImage *image=[[SDImageCache sharedImageCache]imageFromKey:_cell.info.leaderSAvatorUrl];
    if(!image){
      image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_cell.info.leaderSAvatorUrl]]];
      [[SDImageCache sharedImageCache] storeImage:image forKey:_cell.info.leaderSAvatorUrl];
    }
    [avatorBtn setImage:image forState:UIControlStateNormal];
    [self addSubview:avatorBtn];
    [self setTitle];
  }
  UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(55, 185, 240, 20)];
  label.text=@"图片加载中...";
  label.textAlignment=UITextAlignmentCenter;
  label.font=[UIFont fontWithName:@"Arial" size:13];
  label.textColor=[UIColor blackColor];
  label.backgroundColor=[UIColor clearColor];
  [self addSubview:label];
  
}

- (void)setStatus{
  UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(245, 75, 50, 20)];
  UITapGestureRecognizer *labelTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(statusTap:)];
  [label addGestureRecognizer:labelTap];
  label.userInteractionEnabled=YES;
  label.layer.cornerRadius=5;
  label.layer.masksToBounds=YES;
  label.textAlignment=UITextAlignmentCenter;
  label.font=[UIFont fontWithName:@"Arial" size:11];
  label.textColor=[UIColor whiteColor];
  if (![_cell.info isEnd]) {
    label.text=@"进行中";
    label.backgroundColor=[UIColor getColor:ColorOrange];
  }else{
    label.text=@"已结束";
    label.backgroundColor=[UIColor getColor:ColorBlue];
  }
  [self addSubview:label];
}

- (void)setTitle{
  DetailTextView *detailTextView = [[DetailTextView alloc]initWithFrame:CGRectMake(75, 20, 260, 20)];
  detailTextView.backgroundColor=[UIColor clearColor];
  NSString *userCountStr=[NSString stringWithFormat:@" 共%d人 ",_cell.info.userCount];
  
  [detailTextView setText:[NSString stringWithFormat:@"活动: %@   骑友:%@",_cell.info.name,userCountStr] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor blackColor]];
  if(![_cell.info isEnd]){
    [detailTextView setKeyWordTextString:_cell.info.name WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorOrange]];
    [detailTextView setKeyWordTextString:userCountStr WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorOrange]];
  }else{
    [detailTextView setKeyWordTextString:_cell.info.name WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorBlue]];
    [detailTextView setKeyWordTextString:userCountStr WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorBlue]];
  }
  [self addSubview:detailTextView];
  DetailTextView *detailTextView1 = [[DetailTextView alloc]initWithFrame:CGRectMake(75, 40, 260, 20)];
  detailTextView1.backgroundColor=[UIColor clearColor];
  NSString *distance=[NSString stringWithFormat:@"%0.2fKM",_cell.info.distance];
  [detailTextView1 setText:[NSString stringWithFormat:@"行程: %@",distance] WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor blackColor]];
  if(![_cell.info isEnd]){
    [detailTextView1 setKeyWordTextString:distance WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorOrange]];
  }else{
    [detailTextView1 setKeyWordTextString:distance WithFont:[UIFont fontWithName:@"Arial" size:12] AndColor:[UIColor getColor:ColorBlue]];
  }
  [self addSubview:detailTextView1];
  _height+=80;
}

- (void) inputStackView{
  SWSnapshotStackView *stackView=[[SWSnapshotStackView alloc]initWithFrame:CGRectMake(55, 55, 260, 260)];
  stackView.contentMode=UIViewContentModeRedraw;
  stackView.displayAsStack = YES;
  stackView.backgroundColor=[UIColor clearColor];
  
  NSString *urlString=[QiNiuUtils getUrlBySize:stackView.frame.size url:_cell.info.mapAvatorPicUrl type:DEDEFAULT];
  UIImage *image=[[SDImageCache sharedImageCache]imageFromKey:urlString];
  if(!image){
    image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    [[SDImageCache sharedImageCache] storeImage:image forKey:urlString];
  }
//  CGFloat width= CGImageGetWidth([image CGImage]);
//  CGFloat height= CGImageGetHeight([image CGImage]);
//  CGRect frame=stackView.frame;
//  frame.size.width=width/height*frame.size.height;
//  stackView.frame=frame;
  stackView.image=[image resizedImage:stackView.frame.size imageOrientation:UIImageOrientationUp];
  [self addSubview:stackView];
  [self setStatus];
  _height+=260;
}

- (void)leaderViewTap:(id)selector{
  [_cell leaderViewTap:selector];
}


- (CGFloat)getCellHeight{
  return _height+20;
}


- (void)statusTap:(id)selector{
  [_cell statusTap:selector];
}

@end



@implementation QQNRFeedTableCell
@synthesize delegate=_delegate;
@synthesize info=_info;
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

- (CGFloat)getCellHeight{
  return [(CompositeSubviewBasedApplicationCellContentView*)cellContentView getCellHeight];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier info:(ActivityInfo*)info
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor=[UIColor clearColor];
    self.info=info;
  }
  return self;
}

- (void)leaderViewTap:(id)selector{
  if ([self.delegate respondsToSelector:@selector(leaderTap:)]) {
    [self.delegate performSelector:@selector(leaderTap:) withObject:_info];
  }
}


- (void)statusTap:(id)selector{
  if(self.delegate){
    [self.delegate statusTap:self];
  }
}


-(UIView*)resetContentView:(BOOL)needNew;
{
  if(!cellContentView||needNew){
    cellContentView = [[CompositeSubviewBasedApplicationCellContentView alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0) cell:self];
    cellContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cellContentView.contentMode = UIViewContentModeRedraw;
    [cellContentView setNeedsDisplay];
  }
  return cellContentView;
}
@end
