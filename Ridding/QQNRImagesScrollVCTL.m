//
//  MPImagesScrollVCTL.m
//  Phamily
//
//  Created by zys on 12-12-12.
//  Copyright (c) 2013年 zyslovely@gmail.com. All rights reserved.
//

#import "QQNRImagesScrollVCTL.h"

#define LOADCOUNT 10

@interface QQNRImagesScrollVCTL ()

@end

@implementation QQNRImagesScrollVCTL

#define kNavigationBarFadeDelay  3.5

#pragma - Private
- (void)fadeBarAway:(NSTimer *)timer {

  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.35];


  self.barView.alpha = 0.0;

  [UIView commitAnimations];
}

- (void)fadeBarIn {

  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.35];

  self.barView.alpha = 1.0;

  [UIView commitAnimations];
}

- (void)fadeBarController {

  if (self.barView.alpha == 0) {
    [self fadeBarIn];

    if (self.fadeTimer != nil) {
      [self.fadeTimer invalidate];
    }
    self.fadeTimer = [NSTimer
        scheduledTimerWithTimeInterval:kNavigationBarFadeDelay target:self
                              selector:@selector(fadeBarAway:) userInfo:nil repeats:NO];
  } else
    [self fadeBarAway:nil];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil startPageIndex:(NSUInteger)_startPageIndex {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    startPageIndex = _startPageIndex;
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

}

#pragma mark - View lifecycle

- (void)loadView {

  [super loadView];

  // Step 1: make the outer paging scroll view

  CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
  _pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];


  _pagingScrollView.pagingEnabled = YES;
  _pagingScrollView.backgroundColor = [UIColor blackColor];
  _pagingScrollView.showsVerticalScrollIndicator = NO;
  _pagingScrollView.showsHorizontalScrollIndicator = NO;
  _pagingScrollView.contentSize = CGSizeMake(pagingScrollViewFrame.size.width * [self imageCount],
      pagingScrollViewFrame.size.height);
  _pagingScrollView.delegate = self;
  _pagingScrollView.directionalLockEnabled = YES;


  // 设置起始页位置
  CGRect bounds = [_pagingScrollView bounds];
  bounds.origin.x = _pagingScrollView.bounds.size.width * startPageIndex;
  _pagingScrollView.bounds = bounds;

  [self.view addSubview:_pagingScrollView];

  [self.view bringSubviewToFront:self.barView];

  [self.barView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
  [self.barView.leftButton setTitle:@"返回" forState:UIControlStateHighlighted];
  // Step 2: prepare to tile content

  _recycledPages = [[NSMutableSet alloc] init];
  _visiblePages = [[NSMutableSet alloc] init];
  [self changePages];
}


- (void)viewDidLoad {

  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];
  // fade Controller


//  self.barView.alpha=0.0;

  [self wantsFullScreenLayout];

}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {

  [super viewDidDisappear:animated];

  [self.fadeTimer invalidate];
}

#pragma mark - Scrollview Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  [self changePages];
}

#pragma mark - TouchScrollView Delegate
- (void)scrollViewTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

  UITouch *touch = [touches anyObject];
  NSTimeInterval delaytime = 0.4;//自己根据需要调整

  switch (touch.tapCount) {
    case 1:
      [self performSelector:@selector(fadeBarController) withObject:nil afterDelay:delaytime];
      break;
    case 2: {
      [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeBarController) object:nil];

    }
      break;
    default:
      break;
  }
}

- (void)scrollViewTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)scrollViewTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}

#pragma mark -
#pragma mark Public

- (void)changePages {

  // Caclulate which pages should now be visiable
  CGRect visibleBounds = _pagingScrollView.bounds;
  int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
  int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds) - 1) / CGRectGetWidth(visibleBounds));
  firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
  lastNeededPageIndex = MIN(lastNeededPageIndex, [self imageCount] - 1);

  // Recycle no-longer-needed pages
  for (ImageScrollView *page in _visiblePages) {
    if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
      [_recycledPages addObject:page];
      [page removeFromSuperview];
    }
  }

  [_visiblePages minusSet:_recycledPages];

  // add missing pages
  for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
    if (![self isDisplayingPageForIndex:index]) {

      ImageScrollView *page = [self dequeueRecycledPage];
      if (page == nil) {
        page = [[ImageScrollView alloc] init];
        page.touchDelegate = self;
      }

      [self configurePage:page forIndex:index];
      [_pagingScrollView addSubview:page];
      [_visiblePages addObject:page];
    }
  }
}

- (ImageScrollView *)dequeueRecycledPage {

  ImageScrollView *page = [_recycledPages anyObject];
  if (page) {
    [_recycledPages removeObject:page];
  }
  return page;
}

- (void)configurePage:(ImageScrollView *)page forIndex:(NSUInteger)index {

  page.index = index;
  page.frame = [self frameForPageAtIndex:index];

  [self asyncLoadImage:page forIndex:index];
  _picture = [self.photoArray objectAtIndex:index];
  
  [page displayImage:_picture];
}

- (void)asyncLoadImage:(ImageScrollView *)page forIndex:(NSUInteger)index {

  if (index < LOADCOUNT) {
    for (int i = 0; i < index; i++) {
      [page loadOtherImage:[self.photoArray objectAtIndex:i]];
    }
  } else {
    for (int i = index - LOADCOUNT; i < index; i++) {
      [page loadOtherImage:[self.photoArray objectAtIndex:i]];
    }
  }
  if (index + LOADCOUNT > [self.photoArray count]) {
    for (int i = index + 1; i < [self.photoArray count]; i++) {
      [page loadOtherImage:[self.photoArray objectAtIndex:i]];
    }
  } else {
    for (int i = index + 1; i < index + LOADCOUNT; i++) {
      [page loadOtherImage:[self.photoArray objectAtIndex:i]];
    }
  }

}


- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {

  BOOL foundPage = NO;
  for (ImageScrollView *page in _visiblePages) {
    if (page.index == index) {
      foundPage = YES;
      break;
    }
  }
  return foundPage;
}

#pragma mark -
#pragma mark  Frame calculations
#define PADDING  0

- (CGRect)frameForPagingScrollView {

  CGRect frame = [[UIScreen mainScreen] bounds];
  frame.origin.x -= PADDING;
  frame.size.width += (2 * PADDING);

  return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {

  CGRect pagingScrollViewFrame = [self frameForPagingScrollView];

  CGRect pageFrame = pagingScrollViewFrame;
  pageFrame.size.width -= (2 * PADDING);
  pageFrame.origin.x = (pagingScrollViewFrame.size.width * index) + PADDING;
  return pageFrame;
}

#pragma mark -
#pragma mark Images

- (NSUInteger)imageCount {

  static NSUInteger imageCountNum = 0;
  imageCountNum = [self.photoArray count];
  return imageCountNum;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
