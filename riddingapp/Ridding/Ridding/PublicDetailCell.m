//
//  PublicDetailCellViewCell.m
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import "PublicDetailCell.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "UIImage+Utilities.h"
#import "PublicDetailDescView.h"
@interface PublicDetailApplicationCellContentView : UIView
{
  PublicDetailCell *_cell;
    PublicDetailDescView *_descView;
}
@end

@implementation PublicDetailApplicationCellContentView

- (id)initWithFrame:(CGRect)frame cell:(PublicDetailCell *)cell
{
  if (self = [super initWithFrame:frame])
  {
    _cell = cell;
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    [self inputStackView];
    [self initDesc];
  }
  
  return self;
}

- (void) initDesc{
  _descView=[[PublicDetailDescView alloc]initWithFrame:CGRectMake(10, 360, 300, 10)];
  _descView.backgroundColor=[UIColor whiteColor];
  _descView.desc=@"这是一个描述这是一个描述这是一个描述这是一个描述这是一个描述这是一个描述这是一个描述这是一个描述这是一个描述这是一个描述";
  _descView.time=@"周日";
  CGRect frame=[_descView frame];
  CGFloat height=[_descView heightForContent];
  frame.size.height=height;
  _descView.frame=frame;
  [self addSubview:_descView];
  [_descView setNeedsDisplay];
}

- (void) inputStackView{
  UIImageView *stackView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 300, 360)];
  stackView.contentMode=UIViewContentModeRedraw;
  stackView.backgroundColor=[UIColor clearColor];
  UIImage *image=[_cell.info.image croppedImage:stackView.frame];
  stackView.image=image;
  [self addSubview:stackView];
}

- (void)drawRect:(CGRect)rect
{
  
}
@end

@implementation PublicDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier info:(RiddingPicture*)info
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.info=info;
    [self resetContentView];
 
  }
  return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}

- (NSInteger)getCellHeight{
  return _cellContentView.frame.size.height;
}

- (void)imageTap{
  
}



-(UIView*)resetContentView
{
  if(!_cellContentView){
      _cellContentView = [[PublicDetailApplicationCellContentView alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0) cell:self];
    _cellContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _cellContentView.contentMode = UIViewContentModeRedraw;
    [self.contentView addSubview:_cellContentView];
  }
  [_cellContentView setNeedsDisplay];
  return _cellContentView;
}
@end
