//
//  MBImageView_touchDisabled.m
//  MMBang
//
//  Created by zys on 4/4/12.
//  Copyright (c) 2012 骑去哪儿网. All rights reserved.
//

#import "MBImageView_touchDisabled.h"

@implementation MBImageView_touchDisabled

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
  
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
  
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
  
}



@end
