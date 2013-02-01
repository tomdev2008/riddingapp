//
//  TouchEnabledTableView.m
//  MyBabyCare
//
//  Created by Tom on 2/1/12.
//  Copyright (c) 2012 儒果网络. All rights reserved.
//

@implementation TouchEnabledTableView
@synthesize touchDelegate;
@synthesize touchDisabled;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

  if (touchDelegate && !touchDisabled) {
    [touchDelegate onTableView:self touchesBegan:touches withEvent:event];
  }

  [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

  if (touchDelegate && !touchDisabled) {
    [touchDelegate onTableView:self touchesMoved:touches withEvent:event];
  }

  [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

  if (touchDelegate && !touchDisabled) {
    [touchDelegate onTableView:self touchesEnded:touches withEvent:event];
  }

  [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

  if (touchDelegate && !touchDisabled) {
    [touchDelegate onTableView:self touchesCancelled:touches withEvent:event];
  }

  [super touchesCancelled:touches withEvent:event];
}

@end
