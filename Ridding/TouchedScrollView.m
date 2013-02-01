//
//  TouchedScrollView.m
//  MyBabyCare
//
//  Created by Tom CHEN on 10/29/11.
//  Copyright (c) 2011 儒果科技. All rights reserved.
//

#import "TouchedScrollView.h"

@implementation TouchedScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

  if (self.touchDelegate)
    [self.touchDelegate performSelector:@selector(scrollViewTouchesBegan:withEvent:) withObject:touches withObject:event];

  [[self nextResponder] touchesBegan:touches withEvent:event];
  [super touchesBegan:touches withEvent:event];

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

  if (self.touchDelegate) {
    [self.touchDelegate performSelector:@selector(scrollViewTouchesMoved:withEvent:) withObject:touches withObject:event];
  }

  [[self nextResponder] touchesMoved:touches withEvent:event];
  [super touchesMoved:touches withEvent:event];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

  if (self.touchDelegate) {
    [self.touchDelegate performSelector:@selector(scrollViewTouchesEnded:withEvent:) withObject:touches withObject:event];
  }

  [[self nextResponder] touchesEnded:touches withEvent:event];
  [super touchesEnded:touches withEvent:event];
}

@end
