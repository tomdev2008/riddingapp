//
//  MPImagesScrollVCTL.h
//  Phamily
//
//  Created by zys on 12-12-12.
//  Copyright (c) 2013年 zyslovely@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "ImageScrollView.h"

@interface QQNRImagesScrollVCTL : BasicViewController <UIScrollViewDelegate, TouchedScrollViewDelegate> {
  UIScrollView *_pagingScrollView;

  NSMutableSet *_recycledPages;
  NSMutableSet *_visiblePages;

  NSUInteger startPageIndex;

  NSTimer *_fadeTimer;

  RiddingPicture *_picture;

  // show hint
  BOOL showHintAlready;
}

@property (nonatomic, retain) NSArray *photoArray;
@property (nonatomic, retain) NSTimer *fadeTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil startPageIndex:(NSUInteger)_startPageIndex;


@end
