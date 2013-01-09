//
//  SourceLoginViewController.h
//  Ridding
//
//  Created by zys on 12-6-15.
//  Copyright (c) 2012年 用户外域资源登陆的类
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "ActivityView.h"
#import "SVSegmentedControl.h"
@class QQNRSourceLoginViewController;
@protocol QQNRSourceLoginViewControllerDelegate <NSObject>

@optional
- (void)didFinishLogined:(QQNRSourceLoginViewController*)controller;

@end

@interface QQNRSourceLoginViewController : BasicViewController<UIWebViewDelegate>{
  SVSegmentedControl *_redSC;
  BOOL _sendWeiBo;
}

@property(nonatomic, retain) IBOutlet UIWebView *web; 
@property(nonatomic, retain) ActivityView *activityView;
@property(nonatomic, assign) id<QQNRSourceLoginViewControllerDelegate> delegate;
@end
