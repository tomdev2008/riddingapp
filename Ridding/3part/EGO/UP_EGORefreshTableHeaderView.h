//
//  EGORefreshTableHeaderView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//   修改人：禚来强 iphone开发qq群：79190809 邮箱：zhuolaiqiang@gmail.com
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {

  EGOOPullRefreshPulling = 0,
  EGOOPullRefreshNormal,
  EGOOPullRefreshLoading,

} EGOPullRefreshState;

@protocol UP_EGORefreshTableHeaderDelegate;

@interface UP_EGORefreshTableHeaderView : UIView {

  id _delegate;
  EGOPullRefreshState _state;

  UILabel *_lastUpdatedLabel;
  UILabel *_statusLabel;
  CALayer *_arrowImage;
  UIActivityIndicatorView *_activityView;


  NSString *normalStateText;
}

@property (nonatomic, assign) id <UP_EGORefreshTableHeaderDelegate> delegate;

- (void)refreshLastUpdatedDate;

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (id)initWithFrame:(CGRect)frame withBackgroundColor:(UIColor *)bgColor;

- (id)initWithFrame:(CGRect)frame withBackgroundColor:(UIColor *)bgColor normalStatusText:(NSString *)normalText;

@end

@protocol UP_EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(UP_EGORefreshTableHeaderView *)view;

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(UP_EGORefreshTableHeaderView *)view;

@optional
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(UP_EGORefreshTableHeaderView *)view;

@end
