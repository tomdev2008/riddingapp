//
//  ImageSwipeViewController.h
//  Ridding
//
//  Created by Wu Chenhao on 5/8/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSwipeViewController.h"
@protocol ImageSwipeViewDelegate <NSObject>
- (void)startApp;
@end


@interface ImageSwipeViewController : UIViewController <UIScrollViewDelegate> {
  CGRect viewSize;
	UIScrollView *scrollView;
	UIPageControl *pageControl;
	NSArray *imageArray;
}

-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)array;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, assign) id<ImageSwipeViewDelegate> delegate;
@end
