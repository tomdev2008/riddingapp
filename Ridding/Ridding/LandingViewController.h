//
//  LandingViewController.h
//  Ridding
//
//  Created by Chenhao Wu on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSwipeViewController.h"

@interface LandingViewController : UIViewController <ImageSwipeViewDelegate> {
  NSArray *imageList;
  ImageSwipeViewController *imageSwipeViewController;
}

@property (strong, nonatomic) NSArray *imageList;
@property (strong, nonatomic) ImageSwipeViewController *imageSwipeViewController;

- (void)startApp:(UIGestureRecognizer *)gestureRecognizer;

@end
