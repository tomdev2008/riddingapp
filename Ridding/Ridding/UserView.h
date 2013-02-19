//
//  UserScrollView.h
//  Ridding
//
//  Created by zys on 12-3-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "User.h"

@class UserView;

@protocol UserViewDelegate <NSObject>
- (void)avatorBtnClick:(UserView *)userView; 
- (void)deleteBtnClick:(UserView *)userView; 
@end

@interface UserView : UIView {
  
  UIButton *_avatorBtn;
  UIButton *_deleteBtn;
}
@property (nonatomic, assign) id <UserViewDelegate> delegate;
@property (nonatomic, retain) User *user;

- (UserView *)init;

- (void)changeStatus:(int)status;

- (void)showDeleteBtn;

- (void)hideDeleteBtn;
@end



