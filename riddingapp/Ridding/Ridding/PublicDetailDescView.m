//
//  PublicDetailDescView.m
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import "PublicDetailDescView.h"

@implementation PublicDetailDescView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}


-(CGFloat)heightForContent
{
  CGFloat space=10.0;
  CGPoint last = CGPointMake(5, 5);
  CGSize descSize=[self.desc sizeWithFont:[UIFont fontWithName:@"Arial" size:12] constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
  
  last.y+=descSize.height;
  CGSize timeSize=[self.time sizeWithFont:[UIFont fontWithName:@"Arial" size:12] constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:UILineBreakModeWordWrap];
  last.y+=timeSize.height;
  if (space <40) {
    return 40;
  }else {
    return  space+last.y;
  }
}

- (void)drawRect:(CGRect)rect
{
  CGPoint last = CGPointMake(5, 5);
  CGSize descSize=[self.desc drawInRect:CGRectMake(15, last.y, 285, 60) withFont:[UIFont fontWithName:@"Arial" size:12] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
  last.y +=descSize.height ;
  [self.time drawInRect:CGRectMake(15, last.y+descSize.height, 285, 60) withFont:[UIFont fontWithName:@"Arial" size:12] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
}


@end
