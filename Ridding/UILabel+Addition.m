//
//  UILabel+Addition.m
//  GameChat
//
//  Created by zys on 13-2-17.
//  Copyright (c) 2013年 Ruoogle. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel(Addition)

- (void)alignTop {
  CGSize fontSize = [self.text sizeWithFont:self.font];
  double finalHeight = fontSize.height * self.numberOfLines;
  double finalWidth = self.frame.size.width;    //expected width of label
  CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
  int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
  for(int i=0; i<newLinesToPad; i++)
    self.text = [self.text stringByAppendingString:@"\n "];
}
@end
