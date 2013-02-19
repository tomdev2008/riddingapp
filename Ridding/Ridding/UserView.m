//
//  UserScrollView.m
//  Ridding
//
//  Created by zys on 12-3-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "QiNiuUtils.h"

@implementation UserView

- (id)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];
  if (self) {

  }
  return self;
}

- (UserView *)init {
  //添加头像
  _avatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  _avatorBtn.frame = CGRectMake(10, 8, 35, 35);
  _avatorBtn.layer.cornerRadius = 2.0;
  _avatorBtn.clipsToBounds = YES;
  _avatorBtn.layer.borderColor=[[UIColor whiteColor]CGColor];
  _avatorBtn.layer.borderWidth=2.0;
  
  NSURL *url = [QiNiuUtils getUrlBySizeToUrl:_avatorBtn.frame.size url:self.user.bavatorUrl type:QINIUMODE_DESHORT];
  [_avatorBtn setImageWithURL:url placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];
  [_avatorBtn addTarget:self action:@selector(avatorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_avatorBtn];

  //添加名牌
  if ([StaticInfo getSinglton].user.userId == self.user.userId) {
  } else if (self.user.status == 1) {
  } else {
  }



  //添加删除按钮，初始隐藏
  if ([StaticInfo getSinglton].user.isLeader && self.user.userId != [StaticInfo getSinglton].user.userId) {
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(0, 0, 24, 24);
    [_deleteBtn setImage:UIIMAGE_FROMPNG(@"close") forState:UIControlStateNormal];
    [_deleteBtn setImage:UIIMAGE_FROMPNG(@"close") forState:UIControlStateHighlighted];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.hidden = YES;
    [self addSubview:_deleteBtn];
  }
  return self;
}

- (void)changeStatus:(int)status {

  self.user.status = status;
  if ([StaticInfo getSinglton].user.userId == self.user.userId) {
  } else if (status == 1) {
  } else {
  }
}


//点击头像view
- (void)avatorBtnClick:(id)sender {

  if (self.user.status == 1) {
    if ([self.delegate respondsToSelector:@selector(avatorBtnClick:)]) {
      [self.delegate avatorBtnClick:self];
    }
  }
}

//点击删除
- (void)deleteBtnClick:(id)sender {

  if ([self.delegate respondsToSelector:@selector(deleteBtnClick:)]) {
    [self.delegate deleteBtnClick:self];
  }

}


- (void)showDeleteBtn {

  _deleteBtn.hidden = NO;
}

- (void)hideDeleteBtn {

  _deleteBtn.hidden = YES;
}


@end
